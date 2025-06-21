package com.tracky.notificationservice.service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tracky.notificationservice.client.UserServiceClient;
import com.tracky.notificationservice.event.OrderDeliveredEvent;
import com.tracky.notificationservice.model.Notification;
import com.tracky.notificationservice.repository.NotificationRepository;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class NotificationService {

    @Autowired
    private NotificationRepository notificationRepository;

    @Autowired
    private FcmService fcmService;

    @Autowired
    private EmailService emailService;

    @Autowired
    private UserServiceClient userServiceClient;

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

    private void sendCustomerPushNotification(OrderDeliveredEvent event) {
        Notification notification = createNotification(
                event.getOrderId(),
                event.getCustomerId(),
                Notification.NotificationType.ORDER_DELIVERED,
                Notification.NotificationChannel.PUSH,
                "Order Delivered!");

        try {
            // Get customer device token (placeholder - this would normally come from user
            // service)
            String deviceToken = userServiceClient.getCustomerDeviceToken(event.getCustomerId());

            if (deviceToken != null && !deviceToken.isEmpty()) {
                Map<String, String> data = new HashMap<>();
                data.put("orderId", event.getOrderId().toString());
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

        notificationRepository.save(notification);
    }

    private void sendCustomerEmailNotification(OrderDeliveredEvent event) {
        Notification notification = createNotification(
                event.getOrderId(),
                event.getCustomerId(),
                Notification.NotificationType.ORDER_DELIVERED,
                Notification.NotificationChannel.EMAIL,
                "Order Delivered - " + event.getDescription());

        try {
            // Get customer email (placeholder - this would normally come from user service)
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

        notificationRepository.save(notification);
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
            // Get driver email (placeholder - this would normally come from user service)
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

        notificationRepository.save(notification);
    }

    private Notification createNotification(
            java.util.UUID orderId,
            java.util.UUID userId,
            Notification.NotificationType type,
            Notification.NotificationChannel channel,
            String message) {
        Notification notification = new Notification();
        notification.setOrderId(orderId);
        notification.setUserId(userId);
        notification.setType(type);
        notification.setChannel(channel);
        notification.setMessage(message);
        notification.setStatus(Notification.NotificationStatus.PENDING);
        return notification;
    }
}
