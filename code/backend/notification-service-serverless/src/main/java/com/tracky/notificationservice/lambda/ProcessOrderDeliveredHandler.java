package com.tracky.notificationservice.lambda;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.SQSEvent;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.tracky.notificationservice.dto.OrderDeliveredEvent;
import com.tracky.notificationservice.service.EmailService;
import com.tracky.notificationservice.service.FcmService;
import com.tracky.notificationservice.service.NotificationService;
import com.tracky.notificationservice.service.UserServiceClient;
import lombok.extern.slf4j.Slf4j;
import software.amazon.awssdk.enhanced.dynamodb.DynamoDbEnhancedClient;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;

@Slf4j
public class ProcessOrderDeliveredHandler implements RequestHandler<SQSEvent, Void> {
    
    private final NotificationService notificationService;
    private final ObjectMapper objectMapper;
    
    public ProcessOrderDeliveredHandler() {
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
                tableName
        );
        
        this.objectMapper = new ObjectMapper();
        this.objectMapper.registerModule(new JavaTimeModule());
    }
    
    @Override
    public Void handleRequest(SQSEvent event, Context context) {
        log.info("Processing {} order delivered event messages", event.getRecords().size());
        
        for (SQSEvent.SQSMessage message : event.getRecords()) {
            try {
                String messageBody = message.getBody();
                log.info("Processing order delivered event message: {}", messageBody);
                
                OrderDeliveredEvent orderEvent = objectMapper.readValue(
                        messageBody, OrderDeliveredEvent.class);
                        
                notificationService.processOrderDeliveredEvent(orderEvent);
                
                log.info("Successfully processed order delivered event for order: {}", orderEvent.getOrderId());
                
            } catch (Exception e) {
                log.error("Failed to process order delivered event message: {}", message.getBody(), e);
                // In a production system, you might want to send this to a DLQ or implement retry logic
            }
        }
        
        return null;
    }
}
