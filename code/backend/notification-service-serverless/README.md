# Notification Service Serverless

This is the serverless version of the Notification Service, converted from a Spring Boot microservice to AWS Lambda functions.

## Architecture

- **Lambda Functions**: Message processing converted to Lambda functions
- **DynamoDB**: Replaces PostgreSQL for notification storage
- **SQS**: Replaces RabbitMQ for consuming messages
- **FCM**: Firebase Cloud Messaging for push notifications
- **Email**: SMTP for email notifications

## Functions

- `processCampaignNotification`: Processes campaign notification requests
- `processOrderDeliveredEvent`: Processes order delivered events

## Infrastructure

- **DynamoDB Table**: `notification-service-notifications-{stage}`
- **SQS Queues**: 
  - Campaign notifications queue
  - Order delivered events queue
  - Dead letter queues for failed messages

## Prerequisites

- AWS CLI configured with appropriate permissions
- Java 21
- Maven 3.6+
- Node.js 18+ (for Serverless Framework)
- Serverless Framework: `npm install -g serverless`

## Environment Variables

Set these environment variables before deployment:

```bash
# Firebase configuration (required for push notifications)
export FIREBASE_CONFIG='{"type": "service_account", "project_id": "your-project", ...}'

# SMTP configuration (required for email notifications)
export SMTP_HOST="smtp.gmail.com"
export SMTP_PORT="587"
export SMTP_USERNAME="your-email@gmail.com"
export SMTP_PASSWORD="your-app-password"

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

## Message Processing

The service processes messages from SQS queues:

### Campaign Notifications
- **Queue**: `notification-service-campaign-notifications-{stage}`
- **Handler**: `processCampaignNotification`
- **Message Format**:
```json
{
  "deviceToken": "fcm-device-token",
  "email": "user@example.com",
  "message": "Campaign message",
  "userName": "User Name"
}
```

### Order Delivered Events
- **Queue**: `notification-service-order-delivered-{stage}`
- **Handler**: `processOrderDeliveredEvent`
- **Message Format**:
```json
{
  "orderId": "uuid",
  "customerId": "uuid",
  "driverId": "uuid",
  "description": "Order description",
  "originAddress": "Pickup address",
  "destinationAddress": "Delivery address",
  "deliveredAt": "2025-01-01T10:00:00"
}
```

## Monitoring

- CloudWatch Logs: 
  - `sls logs -f processCampaignNotification --tail`
  - `sls logs -f processOrderDeliveredEvent --tail`
- CloudWatch Metrics: Available in AWS Console
- Dead Letter Queues: Monitor for failed messages

## Cleanup

```bash
sls remove --stage dev
```

## Integration with Campaign Service

The notification service should be configured to receive messages from the campaign service SNS topic. Update the campaign service's `serverless.yml` to include the notification service queue subscription:

```yaml
CampaignNotificationTopicSubscription:
  Type: AWS::SNS::Subscription
  Properties:
    Protocol: sqs
    TopicArn: !Ref CampaignNotificationTopic
    Endpoint: !ImportValue notification-service-campaign-queue-dev
```

## Differences from Original Microservice

1. **Database**: PostgreSQL → DynamoDB
2. **Messaging**: RabbitMQ → SQS
3. **Service Discovery**: Consul → Not needed (direct HTTPS calls)
4. **Configuration**: Spring profiles → Environment variables
5. **Deployment**: Docker containers → Lambda functions
6. **Scaling**: Manual/auto-scaling → Automatic based on message volume
