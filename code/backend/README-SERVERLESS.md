# Tracky Serverless Architecture

This directory contains the serverless versions of the Tracky microservices, converted from Spring Boot applications to AWS Lambda functions using the Serverless Framework.

## Overview

### Converted Services

1. **Campaign Service Serverless** (`campaign-service-serverless/`)
   - Manages marketing campaigns
   - API Gateway + Lambda functions
   - DynamoDB for data storage
   - SNS for message publishing

2. **Notification Service Serverless** (`notification-service-serverless/`)
   - Handles push and email notifications
   - SQS-triggered Lambda functions
   - DynamoDB for notification history
   - FCM and SMTP integrations

## Architecture Comparison

| Component | Original Microservice | Serverless Version |
|-----------|----------------------|-------------------|
| **Compute** | Spring Boot + Docker | AWS Lambda |
| **Database** | PostgreSQL | DynamoDB |
| **Messaging** | RabbitMQ | SNS + SQS |
| **API** | Spring Web | API Gateway |
| **Service Discovery** | Consul | Direct HTTPS calls |
| **Configuration** | Spring Profiles | Environment Variables |
| **Scaling** | Manual/Auto-scaling groups | Automatic (Lambda) |
| **Deployment** | Docker Compose | Serverless Framework |

## Benefits of Serverless Architecture

1. **Cost Efficiency**: Pay only for actual usage
2. **Auto Scaling**: Automatic scaling based on demand
3. **Reduced Operational Overhead**: No server management
4. **Built-in High Availability**: Multi-AZ deployment by default
5. **Event-Driven**: Native integration with AWS services

## Prerequisites

- AWS CLI configured with appropriate permissions
- Java 21
- Maven 3.6+
- Node.js 18+
- Serverless Framework: `npm install -g serverless`

## Quick Start

### 1. Deploy All Services

```bash
# Deploy to development environment
./deploy-serverless.sh

# Deploy to production
./deploy-serverless.sh prod us-east-1
```

### 2. Configure Environment Variables

```bash
# For Notification Service
export FIREBASE_CONFIG='{"type": "service_account", "project_id": "your-project", ...}'
export SMTP_HOST="smtp.gmail.com"
export SMTP_PORT="587"
export SMTP_USERNAME="your-email@gmail.com"
export SMTP_PASSWORD="your-app-password"

# Optional: Custom user service URL
export USER_SERVICE_URL="https://your-user-service-url.com"
```

### 3. Deploy Integration

```bash
# Deploy integration configuration
sls deploy -f integration-serverless.yml --stage dev
```

## Service Details

### Campaign Service

- **Endpoints**:
  - `POST /campaigns` - Create campaign
  - `GET /campaigns` - List campaigns
- **Triggers**: HTTP requests via API Gateway
- **Storage**: DynamoDB table
- **Messaging**: Publishes to SNS topic

### Notification Service

- **Functions**:
  - `processCampaignNotification` - Handles campaign notifications
  - `processOrderDeliveredEvent` - Handles order delivery notifications
- **Triggers**: SQS messages
- **Storage**: DynamoDB table
- **Integrations**: FCM, SMTP

## Monitoring and Observability

### CloudWatch Logs

```bash
# Campaign Service
sls logs -f createCampaign -t --stage dev

# Notification Service
sls logs -f processCampaignNotification -t --stage dev
sls logs -f processOrderDeliveredEvent -t --stage dev
```

### CloudWatch Metrics

- Lambda execution metrics
- API Gateway metrics
- DynamoDB metrics
- SQS queue metrics

### Dead Letter Queues

Failed messages are automatically sent to DLQs for investigation and reprocessing.

## Cost Optimization

1. **Lambda**: Configure appropriate memory and timeout settings
2. **DynamoDB**: Use on-demand billing for variable workloads
3. **API Gateway**: Consider using HTTP APIs for lower costs
4. **CloudWatch**: Set log retention policies

## Security

1. **IAM Roles**: Least privilege access for Lambda functions
2. **VPC**: Optional VPC configuration for enhanced security
3. **Encryption**: Enable encryption at rest and in transit
4. **API Gateway**: API keys and throttling

## Testing

### Unit Tests

```bash
# Campaign Service
cd campaign-service-serverless
mvn test

# Notification Service
cd notification-service-serverless
mvn test
```

### Integration Tests

```bash
# Test campaign creation
curl -X POST https://your-api-gateway-url/dev/campaigns \
  -H "Content-Type: application/json" \
  -d '{"message": "Test campaign", "userType": "PREMIUM"}'

# Send test message to SQS
aws sqs send-message \
  --queue-url https://sqs.us-east-1.amazonaws.com/123456789012/notification-service-campaign-notifications-dev \
  --message-body '{"deviceToken":"test","email":"test@example.com","message":"Test","userName":"Test User"}'
```

## Cleanup

```bash
# Remove all services
cd campaign-service-serverless && sls remove --stage dev
cd ../notification-service-serverless && sls remove --stage dev
sls remove -f integration-serverless.yml --stage dev
```

## Migration Strategy

1. **Phase 1**: Deploy serverless services alongside existing microservices
2. **Phase 2**: Configure traffic splitting between old and new services
3. **Phase 3**: Gradually migrate traffic to serverless services
4. **Phase 4**: Decommission original microservices

## Troubleshooting

### Common Issues

1. **Cold Starts**: Configure provisioned concurrency for critical functions
2. **Timeout**: Increase timeout settings for functions that take longer to execute
3. **Memory**: Monitor memory usage and adjust allocation
4. **Permissions**: Ensure Lambda execution roles have necessary permissions

### Debug Commands

```bash
# Check function configuration
sls info --stage dev

# View recent logs
sls logs -f functionName --stage dev --startTime 1h

# Invoke function locally
sls invoke local -f functionName --data '{"test": "data"}'
```

## Next Steps

1. **Performance Tuning**: Optimize Lambda memory and timeout settings
2. **Monitoring**: Set up CloudWatch alarms and dashboards
3. **CI/CD**: Implement automated deployment pipelines
4. **Load Testing**: Test with realistic traffic patterns
5. **Documentation**: Update API documentation and runbooks
