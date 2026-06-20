#!/bin/bash
set -e

cd "$(dirname "$0")"

echo "Installing dependencies..."
npm install

echo "Deploying tsuki-usermanagement..."
npx serverless deploy
