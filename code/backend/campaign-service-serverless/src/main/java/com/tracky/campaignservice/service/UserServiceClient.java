package com.tracky.campaignservice.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.tracky.campaignservice.dto.UserDto;
import lombok.extern.slf4j.Slf4j;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.List;

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

    public List<UserDto> getUsersByType(String userType) {
        try {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(userServiceUrl + "/users?type=" + userType))
                    .header("Content-Type", "application/json")
                    .timeout(Duration.ofSeconds(30))
                    .GET()
                    .build();

            HttpResponse<String> response = httpClient.send(request,
                    HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                return objectMapper.readValue(response.body(), new TypeReference<List<UserDto>>() {
                });
            } else {
                log.error("Failed to get users by type: {}. Status: {}, Body: {}",
                        userType, response.statusCode(), response.body());
                return List.of();
            }
        } catch (Exception e) {
            log.error("Error calling user service for user type: {}", userType, e);
            return List.of();
        }
    }
}
