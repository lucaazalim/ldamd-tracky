package com.tracky.notificationservice.service;

import com.tracky.notificationservice.dto.CampaignNotificationRequest;
import com.tracky.notificationservice.dto.OrderDeliveredEvent;
import com.tracky.notificationservice.model.Notification;
import lombok.extern.slf4j.Slf4j;
import software.amazon.awssdk.enhanced.dynamodb.DynamoDbEnhancedClient;
import software.amazon.awssdk.enhanced.dynamodb.DynamoDbTable;
import software.amazon.awssdk.enhanced.dynamodb.TableSchema;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Slf4j
public class NotificationService {
    
    private final DynamoDbTable<Notification> notificationTable;
    private final FcmService fcmService;
    private final EmailService emailService;
    private final UserServiceClient userServiceClient;
    
    public NotificationService(DynamoDbEnhancedClient dynamoDbClient,
                              FcmService fcmService,
                              EmailService emailService,
                              UserServiceClient userServiceClient,
                              String tableName) {
        this.notificationTable = dynamoDbClient.table(tableName, TableSchema.fromBean(Notification.class));
        this.fcmService = fcmService;
        this.emailService = emailService;
        this.userServiceClient = userServiceClient;
    }
    
    public void processOrderDeliveredEvent(OrderDeliveredEvent event) {
        log.info("Processing order delivered event for order: {}", event.getOrderId());
        
        try {
            // Send push notification to customer
            sendCustomerPushNotification(event);
            
            // Send email notifications to both customer and driver
            sendCustomerEmailNotification(event);
            sendDriverEmailNotification(event);
            
        } catch (Exception e) {
            log.error("Failed to process order delivered event for order: {}", event.getOrderId(), e);
        }
    }
    
    public void processCampaignNotification(CampaignNotificationRequest request) {
        log.info("Processing campaign notification for user: {}", request.getUserName());
        
        try {
            // Send push notification if device token is available
            if (request.getDeviceToken() != null && !request.getDeviceToken().trim().isEmpty()) {
                sendCampaignPushNotification(request);
            }
            
            // Send email notification if email is available
            if (request.getEmail() != null && !request.getEmail().trim().isEmpty()) {
                sendCampaignEmailNotification(request);
            }
            
        } catch (Exception e) {
            log.error("Failed to process campaign notification for user: {}", request.getUserName(), e);
        }
    }
    
    private void sendCustomerPushNotification(OrderDeliveredEvent event) {
        Notification notification = createNotification(
                event.getOrderId(),
                event.getCustomerId(),
                Notification.NotificationType.ORDER_DELIVERED,
                Notification.NotificationChannel.PUSH,
                "Order Delivered!");
                
        try {
            String deviceToken = userServiceClient.getCustomerDeviceToken(event.getCustomerId());
            
            if (deviceToken != null && !deviceToken.isEmpty()) {
                Map<String, String> data = new HashMap<>();
                data.put("orderId", event.getOrderId());
                data.put("type", "order_delivered");
                
                fcmService.sendPushNotification(
                        deviceToken,
                        "Order Delivered!",
                        "Your order has been successfully delivered to " + event.getDestinationAddress(),
                        data);
                        
                notification.setStatus(Notification.NotificationStatus.SENT);
                notification.setSentAt(LocalDateTime.now());
            } else {
                notification.setStatus(Notification.NotificationStatus.FAILED);
                notification.setErrorMessage("Customer device token not found");
            }
        } catch (Exception e) {
            log.error("Failed to send push notification to customer: {}", event.getCustomerId(), e);
            notification.setStatus(Notification.NotificationStatus.FAILED);
            notification.setErrorMessage(e.getMessage());
        }
        
        notificationTable.putItem(notification);
    }
    
    private void sendCustomerEmailNotification(OrderDeliveredEvent event) {
        Notification notification = createNotification(
                event.getOrderId(),
                event.getCustomerId(),
                Notification.NotificationType.ORDER_DELIVERED,
                Notification.NotificationChannel.EMAIL,
                "Order Delivered - " + event.getDescription());
                
        try {
            String customerEmail = userServiceClient.getCustomerEmail(event.getCustomerId());
            
            if (customerEmail != null && !customerEmail.isEmpty()) {
                String subject = "Order Delivered - Tracky";
                String body = String.format(
                        "Dear Customer,\n\n" +
                                "Great news! Your order has been successfully delivered.\n\n" +
                                "Order Details:\n" +
                                "- Order ID: %s\n" +
                                "- Description: %s\n" +
                                "- Delivery Address: %s\n" +
                                "- Delivered At: %s\n\n" +
                                "Thank you for using Tracky!\n\n" +
                                "Best regards,\n" +
                                "The Tracky Team",
                        event.getOrderId(),
                        event.getDescription(),
                        event.getDestinationAddress(),
                        event.getDeliveredAt());
                        
                emailService.sendEmail(customerEmail, subject, body);
                
                notification.setStatus(Notification.NotificationStatus.SENT);
                notification.setSentAt(LocalDateTime.now());
            } else {
                notification.setStatus(Notification.NotificationStatus.FAILED);
                notification.setErrorMessage("Customer email not found");
            }
        } catch (Exception e) {
            log.error("Failed to send email notification to customer: {}", event.getCustomerId(), e);
            notification.setStatus(Notification.NotificationStatus.FAILED);
            notification.setErrorMessage(e.getMessage());
        }
        
        notificationTable.putItem(notification);
    }
    
    private void sendDriverEmailNotification(OrderDeliveredEvent event) {
        if (event.getDriverId() == null) {
            log.warn("No driver assigned to order: {}", event.getOrderId());
            return;
        }
        
        Notification notification = createNotification(
                event.getOrderId(),
                event.getDriverId(),
                Notification.NotificationType.ORDER_DELIVERED,
                Notification.NotificationChannel.EMAIL,
                "Order Delivery Confirmed - " + event.getDescription());
                
        try {
            String driverEmail = userServiceClient.getDriverEmail(event.getDriverId());
            
            if (driverEmail != null && !driverEmail.isEmpty()) {
                String subject = "Order Delivery Confirmed - Tracky";
                String body = String.format(
                        "Dear Driver,\n\n" +
                                "The order delivery has been confirmed.\n\n" +
                                "Order Details:\n" +
                                "- Order ID: %s\n" +
                                "- Description: %s\n" +
                                "- Pickup Address: %s\n" +
                                "- Delivery Address: %s\n" +
                                "- Delivered At: %s\n\n" +
                                "Great job on completing the delivery!\n\n" +
                                "Best regards,\n" +
                                "The Tracky Team",
                        event.getOrderId(),
                        event.getDescription(),
                        event.getOriginAddress(),
                        event.getDestinationAddress(),
                        event.getDeliveredAt());
                        
                emailService.sendEmail(driverEmail, subject, body);
                
                notification.setStatus(Notification.NotificationStatus.SENT);
                notification.setSentAt(LocalDateTime.now());
            } else {
                notification.setStatus(Notification.NotificationStatus.FAILED);
                notification.setErrorMessage("Driver email not found");
            }
        } catch (Exception e) {
            log.error("Failed to send email notification to driver: {}", event.getDriverId(), e);
            notification.setStatus(Notification.NotificationStatus.FAILED);
            notification.setErrorMessage(e.getMessage());
        }
        
        notificationTable.putItem(notification);
    }
    
    private void sendCampaignPushNotification(CampaignNotificationRequest request) {
        try {
            Map<String, String> data = new HashMap<>();
            data.put("type", "campaign");
            data.put("message", request.getMessage());
            
            fcmService.sendPushNotification(
                    request.getDeviceToken(),
                    "Tracky Campaign",
                    request.getMessage(),
                    data);
                    
            log.info("Campaign push notification sent to user: {}", request.getUserName());
        } catch (Exception e) {
            log.error("Failed to send campaign push notification to user: {}", request.getUserName(), e);
        }
    }
    
    private void sendCampaignEmailNotification(CampaignNotificationRequest request) {
        try {
            String subject = "Tracky Campaign - Special Message";
            String body = createCampaignEmailBody(request);
            
            emailService.sendEmail(request.getEmail(), subject, body);
            
            log.info("Campaign email notification sent to user: {}", request.getUserName());
        } catch (Exception e) {
            log.error("Failed to send campaign email notification to user: {}", request.getUserName(), e);
        }
    }
    
    private String createCampaignEmailBody(CampaignNotificationRequest request) {
        String userName = request.getUserName() != null ? request.getUserName() : "Valued Customer";
        
        return String.format("""
                Dear %s,

                %s

                Thank you for using Tracky!

                Best regards,
                The Tracky Team
                """, userName, request.getMessage());
    }
    
    private Notification createNotification(String orderId, String userId, 
                                          Notification.NotificationType type,
                                          Notification.NotificationChannel channel, 
                                          String message) {
        Notification notification = new Notification(orderId, userId, type, channel, message);
        notification.setStatus(Notification.NotificationStatus.PENDING);
        return notification;
    }
}
