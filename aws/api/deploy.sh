#!/usr/bin/env bash
set -euo pipefail

# ── API Gateway deploy ──────────────────────────────────────────────────
#
# Must be run AFTER all Lambda functions have been deployed.
#
# What it does:
#   1. Loads env/.env for API_ID, AWS_REGION and LAMBDA_FUNCTION_NAME_* vars.
#   2. Resolves each LAMBDA_FUNCTION_NAME into a Lambda ARN.
#   3. Substitutes ${LAMBDA_URI_*} placeholders in api.yml with real ARNs.
#   4. Re-imports the OpenAPI spec into the existing HTTP API.
#   5. Grants API Gateway permission to invoke each Lambda.
#   6. Creates a deployment so changes go live immediately.
#
# The output URL is the base URL for all endpoints.
# ─────────────────────────────────────────────────────────────────────────

cd "$(dirname "$0")"

ENV_FILE="env/.env"
if [ -f "$ENV_FILE" ]; then
  echo "Loading environment from $ENV_FILE"
  set -a
  . "$ENV_FILE"
  set +a
fi

if [ -z "${API_ID:-}" ]; then
  echo "API_ID is not set."
  exit 1
fi

if [ -z "${AWS_REGION:-}" ]; then
  echo "AWS_REGION is not set."
  exit 1
fi

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

build_lambda_uri() {
  local function_name="$1"
  printf 'arn:aws:apigateway:%s:lambda:path/2015-03-31/functions/arn:aws:lambda:%s:%s:function:%s/invocations' \
    "$AWS_REGION" "$AWS_REGION" "$ACCOUNT_ID" "$function_name"
}

for env_var in $(compgen -v | grep -E '^LAMBDA_FUNCTION_NAME(_|$)' || true); do
  if [ "$env_var" = "LAMBDA_FUNCTION_NAME" ]; then
    uri_var="LAMBDA_URI"
  else
    uri_var="${env_var/LAMBDA_FUNCTION_NAME/LAMBDA_URI}"
  fi

  if [ -n "${!env_var:-}" ] && [ -z "${!uri_var:-}" ]; then
    export "$uri_var"="$(build_lambda_uri "${!env_var}")"
  fi
done

for env_var in $(compgen -v | grep -E '^LAMBDA_NAME(_|$)' || true); do
  if [ "$env_var" = "LAMBDA_NAME" ]; then
    uri_var="LAMBDA_URI"
  else
    uri_var="${env_var/LAMBDA_NAME/LAMBDA_URI}"
  fi

  if [ -n "${!env_var:-}" ] && [ -z "${!uri_var:-}" ]; then
    export "$uri_var"="$(build_lambda_uri "${!env_var}")"
  fi
done

TEMP_FILE="api-temp.yml"
cp api.yml "$TEMP_FILE"

placeholders=$(grep -o '\${[^}]*}' "$TEMP_FILE" | tr -d '\${}' | sort -u)
for placeholder in $placeholders; do
  if [ -n "${!placeholder:-}" ]; then
    value="${!placeholder}"
  else
    echo "Missing value for placeholder: $placeholder"
    exit 1
  fi

  placeholder_literal="\${${placeholder}}"
  escaped_value=$(printf '%s' "$value" | sed -e 's/[&|\\]/\\&/g')
  sed -i "s|$placeholder_literal|$escaped_value|g" "$TEMP_FILE"
done

CLI_OPTS="--cli-binary-format raw-in-base64-out"

echo "Updating HTTP API: $API_ID"
aws apigatewayv2 reimport-api \
  $CLI_OPTS --api-id "$API_ID" \
  --body "file://$TEMP_FILE"

for env_var in $(compgen -v | grep -E '^LAMBDA_URI(_|$)' || true); do
  if [[ "$env_var" == "LAMBDA_URI" ]]; then
    function_name="${LAMBDA_FUNCTION_NAME:-}"
  else
    name_var="${env_var/LAMBDA_URI/LAMBDA_FUNCTION_NAME}"
    function_name="${!name_var:-}"
  fi

  if [ -n "${!env_var:-}" ] && [ -z "$function_name" ]; then
    function_name=$(echo "${!env_var}" | sed -E 's|.*/function:([^/]+)/invocations$|\1|')
  fi

  if [ -n "$function_name" ]; then
      aws lambda add-permission \
        --function-name "$function_name" \
        --statement-id "apigateway-invoke-$function_name" \
        --action lambda:InvokeFunction \
        --principal apigateway.amazonaws.com \
        --source-arn "arn:aws:execute-api:$AWS_REGION:$ACCOUNT_ID:$API_ID/*/*" \
        2>/dev/null || true
  fi
done

aws apigatewayv2 create-deployment \
  --api-id "$API_ID" --stage-name '$default' 2>/dev/null || true

echo "https://$API_ID.execute-api.$AWS_REGION.amazonaws.com"
rm -f "$TEMP_FILE"
