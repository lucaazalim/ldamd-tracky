#!/bin/bash

# Campaign Service Serverless Deployment Script

set -e

STAGE=${1:-dev}
REGION=${2:-us-east-1}

echo "🚀 Deploying Campaign Service Serverless to stage: $STAGE, region: $REGION"

# Check if Serverless Framework is installed
if ! command -v sls &> /dev/null; then
    echo "❌ Serverless Framework not found. Installing..."
    npm install -g serverless
fi

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Build the Java application
echo "🔨 Building Java application..."
./build.sh

# Deploy to AWS
echo "☁️ Deploying to AWS..."
sls deploy --stage $STAGE --region $REGION

echo "✅ Campaign Service Serverless deployed successfully!"
echo ""
echo "📋 Stack Outputs:"
sls info --stage $STAGE --region $REGION
