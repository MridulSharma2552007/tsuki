#!/bin/bash
set -e

cd "$(dirname "$0")"

echo "Installing dependencies..."
npm install

echo "Deploying tsuki-streamer..."
npx serverless deploy
