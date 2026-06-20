#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

ENV_FILE="env/.env"
if [ -f "$ENV_FILE" ]; then
  echo "Loading environment from $ENV_FILE"
  set -a; . "$ENV_FILE"; set +a
fi

if [ -z "${API_ID:-}" ]; then echo "API_ID is not set."; exit 1; fi
if [ -z "${AWS_REGION:-}" ]; then echo "AWS_REGION is not set."; exit 1; fi

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
LAMBDA_URI="arn:aws:apigateway:$AWS_REGION:lambda:path/2015-03-31/functions/arn:aws:lambda:$AWS_REGION:$ACCOUNT_ID:function:tsuki-usermanagement/invocations"

TEMP_FILE="api-temp.yml"
cp api.yml "$TEMP_FILE"
sed -i "s|\${LAMBDA_URI}|$LAMBDA_URI|g" "$TEMP_FILE"

CLI_OPTS="--cli-binary-format raw-in-base64-out"

echo "Updating HTTP API: $API_ID"
aws apigatewayv2 reimport-api \
  $CLI_OPTS --api-id "$API_ID" \
  --body "file://$TEMP_FILE"

aws lambda add-permission \
  --function-name tsuki-usermanagement \
  --statement-id apigateway-invoke \
  --action lambda:InvokeFunction \
  --principal apigateway.amazonaws.com \
  --source-arn "arn:aws:execute-api:$AWS_REGION:$ACCOUNT_ID:$API_ID/*/*" \
  2>/dev/null || true

aws apigatewayv2 create-deployment \
  --api-id "$API_ID" --stage-name '$default' 2>/dev/null || true

echo "https://$API_ID.execute-api.$AWS_REGION.amazonaws.com"
rm -f "$TEMP_FILE"
