#!/bin/bash
set -e

cd "$(dirname "$0")"

echo "Deploying tsuki-streamer..."
npx serverless@3.40.0 deploy
