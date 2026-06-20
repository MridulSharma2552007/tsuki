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

if [[ -n "$STACK_STATUS" && "$STACK_STATUS" != "None" ]]; then
  echo "Existing stack found in $STACK_STATUS — deleting for fresh deploy..."
  aws cloudformation delete-stack --stack-name "$STACK_NAME" --region "$REGION"
  aws cloudformation wait stack-delete-complete \
    --stack-name "$STACK_NAME" --region "$REGION" || true
  echo "Stack deleted."
fi

npx serverless deploy --stage "$STAGE" --region "$REGION"
