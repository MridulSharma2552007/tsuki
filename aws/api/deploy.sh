#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

if [ $# -lt 1 ]; then
  echo "Usage: $0 <environment> [aws_region_override]"
  exit 1
fi

ENVIRONMENT="$1"
AWS_REGION_OVERRIDE="${2:-}"

ENV_FILE="env/.env.$ENVIRONMENT"
if [ -f "$ENV_FILE" ]; then
  echo "Loading environment variables from $ENV_FILE"
  set -a; . "$ENV_FILE"; set +a
  if [ -n "${CI:-}" ] || [ -n "${GITHUB_ACTIONS:-}" ]; then
    unset AWS_PROFILE
  fi
fi

if [ -n "$AWS_REGION_OVERRIDE" ]; then AWS_REGION="$AWS_REGION_OVERRIDE"; fi
if [ -z "${AWS_REGION:-}" ]; then echo "AWS_REGION is not set."; exit 1; fi

echo "=================================================="
echo "Tsuki API Import Script"
echo "Environment: $ENVIRONMENT | Region: $AWS_REGION"
echo "=================================================="

API_NAME="${API_NAME:-tsuki-api}"
API_FILE="api.yml"
TEMP_FILE="api-temp.yml"
cp "$API_FILE" "$TEMP_FILE"

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

sed -i "s/{AWS::AccountId}/$ACCOUNT_ID/g" "$TEMP_FILE"

API_ID=$(aws apigateway get-rest-apis \
  --query "items[?name=='$API_NAME'].id" --output text)

CLI_OPTS="--cli-binary-format raw-in-base64-out"

if [ -z "$API_ID" ]; then
  echo "Creating new REST API..."
  API_ID=$(aws apigateway import-rest-api \
    $CLI_OPTS \
    --parameters endpointConfigurationTypes=REGIONAL \
    --body "file://$TEMP_FILE" \
    --query "id" --output text)
  echo "Created API ID: $API_ID"
else
  echo "Updating existing REST API: $API_ID"
  aws apigateway put-rest-api \
    $CLI_OPTS \
    --rest-api-id "$API_ID" \
    --mode overwrite \
    --body "file://$TEMP_FILE"
fi

LAMBDA_FUNCTION="tsuki-usermanagement-$ENVIRONMENT-health"
aws lambda add-permission \
  --function-name "$LAMBDA_FUNCTION" \
  --statement-id apigateway-invoke \
  --action lambda:InvokeFunction \
  --principal apigateway.amazonaws.com \
  --source-arn "arn:aws:execute-api:$AWS_REGION:$ACCOUNT_ID:$API_ID/*" \
  2>/dev/null || true

aws apigateway create-deployment \
  --rest-api-id "$API_ID" \
  --stage-name "$ENVIRONMENT" \
  --description "Deploy from $(git rev-parse --short HEAD 2>/dev/null || echo unknown)"

echo "=================================================="
echo "API Endpoint: https://$API_ID.execute-api.$AWS_REGION.amazonaws.com/$ENVIRONMENT"
echo "=================================================="

rm -f "$TEMP_FILE"
