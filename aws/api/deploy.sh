#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

API_NAME="tsuki-api"
SPEC_FILE="api.yml"
LAMBDA_FUNCTION="tsuki-usermanagement-prod-health"

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
TEMP_FILE="api-temp.yml"
cp "$SPEC_FILE" "$TEMP_FILE"
sed -i "s/{AWS::AccountId}/$ACCOUNT_ID/g" "$TEMP_FILE"

CLI_OPTS="--cli-binary-format raw-in-base64-out"

API_ID=$(aws apigatewayv2 get-apis \
  --query "Items[?Name=='$API_NAME'].ApiId" --output text)

if [ -z "$API_ID" ]; then
  echo "Creating new HTTP API..."
  API_ID=$(aws apigatewayv2 import-api \
    $CLI_OPTS --name "$API_NAME" \
    --body "file://$TEMP_FILE" --query "ApiId" --output text)
else
  echo "Updating HTTP API: $API_ID"
  aws apigatewayv2 reimport-api \
    $CLI_OPTS --api-id "$API_ID" \
    --body "file://$TEMP_FILE"
fi

aws lambda add-permission \
  --function-name "$LAMBDA_FUNCTION" \
  --statement-id apigateway-invoke \
  --action lambda:InvokeFunction \
  --principal apigateway.amazonaws.com \
  --source-arn "arn:aws:execute-api:ap-south-1:$ACCOUNT_ID:$API_ID/*/*" \
  2>/dev/null || true

aws apigatewayv2 create-deployment \
  --api-id "$API_ID" --stage-name prod 2>/dev/null || true

echo "https://$API_ID.execute-api.ap-south-1.amazonaws.com/prod/health"
rm -f "$TEMP_FILE"
