#!/bin/bash

# Tracky Serverless Services Deployment Script

set -e

STAGE=${1:-dev}
REGION=${2:-us-east-1}

echo "🚀 Deploying Tracky Serverless Services to stage: $STAGE, region: $REGION"
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
echo "🔍 Checking prerequisites..."

if ! command_exists sls; then
    echo "❌ Serverless Framework not found. Installing..."
    npm install -g serverless
fi

if ! command_exists mvn; then
    echo "❌ Maven not found. Please install Maven 3.6+ and try again."
    exit 1
fi

echo "✅ Prerequisites checked"
echo ""

# Deploy Campaign Service
echo "📦 Deploying Campaign Service Serverless..."
cd campaign-service-serverless
./deploy.sh $STAGE $REGION
cd ..
echo ""

# Deploy Notification Service
echo "📦 Deploying Notification Service Serverless..."
cd notification-service-serverless
./deploy.sh $STAGE $REGION
cd ..
echo ""

echo "🎉 All services deployed successfully!"
echo ""
echo "📋 Service Information:"
echo "Campaign Service:"
cd campaign-service-serverless
sls info --stage $STAGE --region $REGION
cd ..
echo ""
echo "Notification Service:"
cd notification-service-serverless
sls info --stage $STAGE --region $REGION
cd ..

echo ""
echo "🔗 Next Steps:"
echo "1. Update the campaign service SNS topic to send messages to notification service SQS queues"
echo "2. Configure environment variables for email and Firebase"
echo "3. Test the services with sample requests"
