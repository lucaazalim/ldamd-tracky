package com.tracky.notificationservice.service;

import java.util.Map;

import org.springframework.stereotype.Service;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class FcmService {

    public void sendPushNotification(String deviceToken, String title, String body, Map<String, String> data) {
        try {
            // Build the notification
            Notification notification = Notification.builder()
                    .setTitle(title)
                    .setBody(body)
                    .build();

            // Build the message
            Message.Builder messageBuilder = Message.builder()
                    .setToken(deviceToken)
                    .setNotification(notification);

            // Add data payload if provided
            if (data != null && !data.isEmpty()) {
                messageBuilder.putAllData(data);
            }

            Message message = messageBuilder.build();

            // Send the message using Firebase Admin SDK
            String response = FirebaseMessaging.getInstance().send(message);

            log.info("FCM notification sent successfully. Message ID: {}", response);

        } catch (Exception e) {
            log.error("Failed to send FCM notification to token: {}", deviceToken, e);
            throw new RuntimeException("Failed to send push notification", e);
        }
    }
}
