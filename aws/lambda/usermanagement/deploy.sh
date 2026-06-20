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

if [[ "$STACK_STATUS" == *ROLLBACK* || "$STACK_STATUS" == *FAILED* ]]; then
  echo "Stack in $STACK_STATUS — removing before redeploy..."
  aws cloudformation delete-stack --stack-name "$STACK_NAME" --region "$REGION" || true
  aws cloudformation wait stack-delete-complete \
    --stack-name "$STACK_NAME" --region "$REGION" || true
fi

if [ "$STACK_STATUS" = "DELETE_FAILED" ]; then
  echo "Stack in DELETE_FAILED — retrying deletion..."
  for i in $(seq 1 30); do
    aws cloudformation delete-stack --stack-name "$STACK_NAME" --region "$REGION" 2>/dev/null || true
    sleep 10
    CURRENT=$(aws cloudformation describe-stacks \
      --stack-name "$STACK_NAME" --region "$REGION" \
      --query 'Stacks[0].StackStatus' --output text 2>/dev/null) || CURRENT=""
    if [ -z "$CURRENT" ]; then
      echo "Stack deleted."
      break
    fi
    if [[ "$CURRENT" != *DELETE* && "$CURRENT" != *FAILED* ]]; then
      echo "Stack transitioned to $CURRENT."
      break
    fi
    echo "Waiting for stack deletion... ($i/30)"
  done
fi

npx serverless deploy --stage "$STAGE" --region "$REGION"
