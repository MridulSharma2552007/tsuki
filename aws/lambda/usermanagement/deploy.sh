#!/bin/bash
set -e

SCRIPT_DIR="$(dirname "$0")"
cd "$SCRIPT_DIR"

STAGE=${STAGE:-dev}
REGION=${REGION:-${AWS_REGION:-ap-south-1}}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -s|--stage) STAGE="$2"; shift 2;;
    -r|--region) REGION="$2"; shift 2;;
    *) shift;;
  esac
done

ENV_FILE="env/.env.$STAGE"
if [ -f "$ENV_FILE" ]; then
  echo "Loading environment variables from $ENV_FILE"
  set -a; source "$ENV_FILE"; set +a
fi

echo "Installing dependencies..."
npm install

echo "Deploying tsuki-usermanagement to stage: $STAGE, region: $REGION"

STACK_NAME="tsuki-usermanagement-$STAGE"
STACK_STATUS=$(aws cloudformation describe-stacks \
  --stack-name "$STACK_NAME" --region "$REGION" \
  --query 'Stacks[0].StackStatus' --output text 2>/dev/null || true)

delete_stack() {
  echo "Deleting stack: $STACK_NAME"
  for i in $(seq 1 60); do
    aws cloudformation delete-stack --stack-name "$STACK_NAME" --region "$REGION" 2>/dev/null || true
    sleep 10
    CURRENT=$(aws cloudformation describe-stacks \
      --stack-name "$STACK_NAME" --region "$REGION" \
      --query 'Stacks[0].StackStatus' --output text 2>/dev/null) || CURRENT=""
    if [ -z "$CURRENT" ]; then
      echo "Stack deleted."
      return 0
    fi
    if [[ "$CURRENT" != *DELETE* && "$CURRENT" != *FAILED* ]]; then
      echo "Stack transitioned to $CURRENT."
      return 0
    fi
    echo "Waiting for stack deletion... ($i/60)"
  done
  echo "Warning: Stack still not deleted after 10 minutes."
}

cleanup_failed() {
  echo "Cleaning up resources blocking deletion..."
  for bucket in $(aws cloudformation list-stack-resources \
    --stack-name "$STACK_NAME" --region "$REGION" \
    --query "StackResourceSummaries[?ResourceType=='AWS::S3::Bucket'].PhysicalResourceId" \
    --output text 2>/dev/null || true); do
    echo "Emptying S3 bucket: $bucket"
    aws s3 rm "s3://$bucket" --recursive --region "$REGION" 2>/dev/null || true
    echo "Deleting S3 bucket: $bucket"
    aws s3 rb "s3://$bucket" --force --region "$REGION" 2>/dev/null || true
  done
}

if [[ "$STACK_STATUS" == *ROLLBACK* || "$STACK_STATUS" == *FAILED* ]]; then
  cleanup_failed
  delete_stack
fi

if [ "$STACK_STATUS" = "DELETE_FAILED" ]; then
  cleanup_failed
  echo "Trying force deletion for DELETE_FAILED stack..."
  aws cloudformation delete-stack --stack-name "$STACK_NAME" \
    --region "$REGION" --deletion-mode FORCE_DELETE_STACK 2>/dev/null || true
  delete_stack
fi

npx serverless deploy --stage "$STAGE" --region "$REGION"
