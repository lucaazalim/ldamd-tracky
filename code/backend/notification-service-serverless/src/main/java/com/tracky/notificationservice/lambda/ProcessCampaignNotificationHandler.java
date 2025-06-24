package com.tracky.notificationservice.lambda;

import javax.naming.Context;
import javax.swing.plaf.synth.Region;

import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.SQSEvent;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;

import lombok.extern.slf4j.Slf4j;
import main.java.com.tracky.notificationservice.dto.CampaignNotificationRequest;
import main.java.com.tracky.notificationservice.service.EmailService;
import main.java.com.tracky.notificationservice.service.FcmService;
import main.java.com.tracky.notificationservice.service.NotificationService;
import software.amazon.awssdk.enhanced.dynamodb.DynamoDbEnhancedClient;
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;

@Slf4j
public class ProcessCampaignNotificationHandler implements RequestHandler<SQSEvent, Void> {

    private final NotificationService notificationService;
    private final ObjectMapper objectMapper;

    public ProcessCampaignNotificationHandler() {
        String region = System.getenv("REGION");
        String tableName = System.getenv("NOTIFICATION_TABLE");
        String userServiceUrl = System.getenv("USER_SERVICE_URL");
        String firebaseConfig = System.getenv("FIREBASE_CONFIG");
        String smtpHost = System.getenv("SMTP_HOST");
        String smtpPort = System.getenv("SMTP_PORT");
        String smtpUsername = System.getenv("SMTP_USERNAME");
        String smtpPassword = System.getenv("SMTP_PASSWORD");

        DynamoDbClient dynamoDbClient = DynamoDbClient.builder()
                .region(Region.of(region))
                .build();

        DynamoDbEnhancedClient enhancedClient = DynamoDbEnhancedClient.builder()
                .dynamoDbClient(dynamoDbClient)
                .build();

        FcmService fcmService = new FcmService(firebaseConfig);
        EmailService emailService = new EmailService(smtpHost, smtpPort, smtpUsername, smtpPassword);
        UserServiceClient userServiceClient = new UserServiceClient(userServiceUrl);

        this.notificationService = new NotificationService(
                enhancedClient,
                fcmService,
                emailService,
                userServiceClient,
                tableName);

        this.objectMapper = new ObjectMapper();
        this.objectMapper.registerModule(new JavaTimeModule());
    }

    @Override
    public Void handleRequest(SQSEvent event, Context context) {
        log.info("Processing {} campaign notification messages", event.getRecords().size());

        for (SQSEvent.SQSMessage message : event.getRecords()) {
            try {
                String messageBody = message.getBody();
                log.info("Processing campaign notification message: {}", messageBody);

                CampaignNotificationRequest request = objectMapper.readValue(
                        messageBody, CampaignNotificationRequest.class);

                notificationService.processCampaignNotification(request);

                log.info("Successfully processed campaign notification for user: {}", request.getUserName());

            } catch (Exception e) {
                log.error("Failed to process campaign notification message: {}", message.getBody(), e);
                // In a production system, you might want to send this to a DLQ or implement
                // retry logic
            }
        }

        return null;
    }
}
