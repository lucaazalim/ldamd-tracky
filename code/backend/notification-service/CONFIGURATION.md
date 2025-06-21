# Notification Service Configuration

The notification service requires additional configuration for Firebase Cloud Messaging (FCM) and Gmail SMTP to work properly.

## Firebase Cloud Messaging (FCM) Setup

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or use an existing one
3. Go to Project Settings > Cloud Messaging
4. Copy your Server Key
5. Replace `your-fcm-server-key-here` in the docker-compose.yml with your actual FCM server key

## Gmail SMTP Setup

1. Create an App Password for your Gmail account:

   - Go to your Google Account settings
   - Security > 2-Step Verification (must be enabled)
   - App passwords > Select app (Mail) and device
   - Generate an app password

2. Replace the placeholder values in docker-compose.yml:
   - `your-email@gmail.com` with your Gmail address
   - `your-app-password` with the generated app password

## Environment Variables

The following environment variables need to be configured:

```yaml
FCM_SERVER_KEY: your-fcm-server-key-here
SMTP_HOST: smtp.gmail.com
SMTP_PORT: 587
SMTP_USERNAME: your-email@gmail.com
SMTP_PASSWORD: your-app-password
```

## Testing the Flow

1. Start all services: `docker-compose up -d`
2. Create an order via the API Gateway
3. Update the order status to DELIVERED
4. Check the notification service logs: `docker-compose logs notification-service`
5. Verify that push notifications and emails are sent

## Placeholder Implementation Notes

The current implementation includes placeholder methods for retrieving customer and driver information from the user service. In a production environment, these would make actual HTTP calls to the user service to get:

- Customer email addresses
- Driver email addresses
- Customer device tokens for push notifications

The placeholder methods currently generate mock data for testing purposes.
