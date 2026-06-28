#!/bin/bash
set -e

# ── Streamer Lambda deploy ──────────────────────────────────────────────
#
# 1. Run this script from anywhere (it cds into its own directory).
# 2. npm installs serverless-python-requirements plugin.
# 3. serverless packages the Python code + yt-dlp into a Lambda layer and
#    uploads the function to AWS.
#
# After this, also run:
#   aws/api/deploy.sh
# to update the API Gateway with the new Lambda ARN.
# ─────────────────────────────────────────────────────────────────────────

cd "$(dirname "$0")"

echo "Installing dependencies..."
npm install

echo "Deploying tsuki-streamer..."
npx serverless@3.40.0 deploy
