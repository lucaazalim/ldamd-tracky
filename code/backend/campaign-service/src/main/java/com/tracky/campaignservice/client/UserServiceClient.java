package com.tracky.campaignservice.client;

import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import com.tracky.campaignservice.dto.UserDto;
import com.tracky.campaignservice.model.Campaign;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * Client for communicating with the User Service.
 */
@Component
@Slf4j
@RequiredArgsConstructor
public class UserServiceClient {

    private final RestTemplate restTemplate;

    @Value("${app.user-service.url:http://user-service:8081}")
    private String userServiceUrl;

    /**
     * Retrieves users by type from the User Service.
     * 
     * @param userType The type of users to retrieve
     * @return List of users matching the specified type
     */
    public List<UserDto> getUsersByType(Campaign.UserType userType) {
        try {
            String url = userServiceUrl + "/users?type=" + userType.name();
            log.info("Calling User Service: {}", url);

            ResponseEntity<List<UserDto>> response = restTemplate.exchange(
                    url,
                    HttpMethod.GET,
                    null,
                    new ParameterizedTypeReference<List<UserDto>>() {
                    });

            List<UserDto> users = response.getBody();
            log.info("Retrieved {} users of type {}", users != null ? users.size() : 0, userType);
            return users;
        } catch (Exception e) {
            log.error("Failed to retrieve users of type {} from User Service", userType, e);
            throw new RuntimeException("Failed to retrieve users from User Service", e);
        }
    }
}
