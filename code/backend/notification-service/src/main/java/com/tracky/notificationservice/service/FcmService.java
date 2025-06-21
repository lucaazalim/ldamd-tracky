package com.tracky.notificationservice.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class FcmService {

    private final RestTemplate restTemplate;

    @Value("${app.fcm.server-key}")
    private String fcmServerKey;

    private static final String FCM_URL = "https://fcm.googleapis.com/fcm/send";

    public FcmService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    public void sendPushNotification(String deviceToken, String title, String body, Map<String, String> data) {
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.set("Authorization", "key=" + fcmServerKey);

            Map<String, Object> message = new HashMap<>();
            message.put("to", deviceToken);

            Map<String, String> notification = new HashMap<>();
            notification.put("title", title);
            notification.put("body", body);
            message.put("notification", notification);

            if (data != null && !data.isEmpty()) {
                message.put("data", data);
            }

            HttpEntity<Map<String, Object>> request = new HttpEntity<>(message, headers);

            String response = restTemplate.postForObject(FCM_URL, request, String.class);
            log.info("FCM notification sent successfully. Response: {}", response);

        } catch (Exception e) {
            log.error("Failed to send FCM notification", e);
            throw new RuntimeException("Failed to send push notification", e);
        }
    }
}
