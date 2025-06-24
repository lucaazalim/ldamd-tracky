# Campaign Service Serverless

This is the serverless version of the Campaign Service, converted from a Spring Boot microservice to AWS Lambda functions.

## Architecture

- **Lambda Functions**: API endpoints converted to Lambda functions
- **DynamoDB**: Replaces PostgreSQL for campaign storage
- **SNS**: Replaces RabbitMQ for publishing campaign notifications
- **API Gateway**: Provides REST API endpoints

## Functions

- `createCampaign`: Creates and executes campaigns
- `getAllCampaigns`: Retrieves all campaigns

## Infrastructure

- **DynamoDB Table**: `campaign-service-campaigns-{stage}`
- **SNS Topic**: Campaign notifications
- **SQS Queue**: Campaign notification queue (subscribed to SNS)

## Prerequisites

- AWS CLI configured with appropriate permissions
- Java 21
- Maven 3.6+
- Node.js 18+ (for Serverless Framework)
- Serverless Framework: `npm install -g serverless`

## Environment Variables

Set these environment variables before deployment:

```bash
# Optional: Set custom user service URL (defaults to https://api.tracky.com/users)
export USER_SERVICE_URL="https://your-user-service-url.com"
```

## Deployment

### Quick Deployment
```bash
# Deploy to dev stage
./deploy.sh

# Deploy to production
./deploy.sh prod us-east-1
```

### Manual Deployment
```bash
# Install dependencies
npm install

# Build Java application
./build.sh

# Deploy to AWS
sls deploy --stage dev --region us-east-1
```

## API Endpoints

After deployment, the service will provide these endpoints:

- `POST /campaigns` - Create a new campaign
- `GET /campaigns` - Get all campaigns

## Usage Example

```bash
# Create a campaign
curl -X POST https://your-api-gateway-url/dev/campaigns \
  -H "Content-Type: application/json" \
  -d '{
    "message": "Special offer for premium users!",
    "userType": "PREMIUM"
  }'

# Get all campaigns
curl https://your-api-gateway-url/dev/campaigns
```

## Monitoring

- CloudWatch Logs: `sls logs -f createCampaign --tail`
- CloudWatch Metrics: Available in AWS Console

## Cleanup

```bash
sls remove --stage dev
```

## Differences from Original Microservice

1. **Database**: PostgreSQL → DynamoDB
2. **Messaging**: RabbitMQ → SNS/SQS
3. **Service Discovery**: Consul → Not needed (direct HTTPS calls)
4. **Configuration**: Spring profiles → Environment variables
5. **Deployment**: Docker containers → Lambda functions
