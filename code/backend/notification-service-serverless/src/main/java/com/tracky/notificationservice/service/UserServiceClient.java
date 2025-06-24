package com.tracky.notificationservice.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;

@Slf4j
public class UserServiceClient {
    
    private final HttpClient httpClient;
    private final ObjectMapper objectMapper;
    private final String userServiceUrl;
    
    public UserServiceClient(String userServiceUrl) {
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();
        this.objectMapper = new ObjectMapper();
        this.userServiceUrl = userServiceUrl;
    }
    
    public String getCustomerDeviceToken(String customerId) {
        return getUserField(customerId, "deviceToken");
    }
    
    public String getCustomerEmail(String customerId) {
        return getUserField(customerId, "email");
    }
    
    public String getDriverEmail(String driverId) {
        return getUserField(driverId, "email");
    }
    
    private String getUserField(String userId, String field) {
        try {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(userServiceUrl + "/users/" + userId))
                    .header("Content-Type", "application/json")
                    .timeout(Duration.ofSeconds(30))
                    .GET()
                    .build();
                    
            HttpResponse<String> response = httpClient.send(request, 
                    HttpResponse.BodyHandlers.ofString());
                    
            if (response.statusCode() == 200) {
                var userData = objectMapper.readValue(response.body(), new TypeReference<java.util.Map<String, Object>>() {});
                return (String) userData.get(field);
            } else {
                log.error("Failed to get user {}: {}. Status: {}, Body: {}", 
                        userId, field, response.statusCode(), response.body());
                return null;
            }
        } catch (Exception e) {
            log.error("Error calling user service for user {} field {}", userId, field, e);
            return null;
        }
    }
}
