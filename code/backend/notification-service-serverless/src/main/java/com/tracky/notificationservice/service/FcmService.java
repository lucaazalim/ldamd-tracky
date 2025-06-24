package com.tracky.notificationservice.service;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import lombok.extern.slf4j.Slf4j;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.util.Map;

@Slf4j
public class FcmService {
    
    private FirebaseMessaging firebaseMessaging;
    
    public FcmService(String firebaseConfig) {
        initializeFirebase(firebaseConfig);
    }
    
    private void initializeFirebase(String firebaseConfig) {
        try {
            if (firebaseConfig == null || firebaseConfig.trim().isEmpty()) {
                log.warn("Firebase configuration not provided. FCM service will not be available.");
                return;
            }
            
            GoogleCredentials googleCredentials = GoogleCredentials
                    .fromStream(new ByteArrayInputStream(firebaseConfig.getBytes()));
                    
            FirebaseOptions firebaseOptions = FirebaseOptions.builder()
                    .setCredentials(googleCredentials)
                    .build();
                    
            FirebaseApp app = FirebaseApp.initializeApp(firebaseOptions, "TrackyApp");
            this.firebaseMessaging = FirebaseMessaging.getInstance(app);
            
            log.info("Firebase initialized successfully");
        } catch (IOException e) {
            log.error("Failed to initialize Firebase", e);
        }
    }
    
    public void sendPushNotification(String deviceToken, String title, String body, Map<String, String> data) {
        if (firebaseMessaging == null) {
            log.warn("Firebase messaging not initialized. Cannot send push notification.");
            return;
        }
        
        try {
            Notification notification = Notification.builder()
                    .setTitle(title)
                    .setBody(body)
                    .build();
                    
            Message.Builder messageBuilder = Message.builder()
                    .setToken(deviceToken)
                    .setNotification(notification);
                    
            if (data != null && !data.isEmpty()) {
                messageBuilder.putAllData(data);
            }
            
            Message message = messageBuilder.build();
            
            String response = firebaseMessaging.send(message);
            log.info("Successfully sent push notification: {}", response);
            
        } catch (Exception e) {
            log.error("Failed to send push notification to token: {}", deviceToken, e);
            throw new RuntimeException("Failed to send push notification", e);
        }
    }
}
