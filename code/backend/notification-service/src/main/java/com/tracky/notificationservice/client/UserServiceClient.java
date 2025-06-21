package com.tracky.notificationservice.client;

import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import com.tracky.notificationservice.dto.UserResponse;

import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class UserServiceClient {

    @Autowired
    private RestTemplate restTemplate;

    private static final String USER_SERVICE_URL = "http://user-service:8081";

    /**
     * Retrieves user information by user ID.
     * 
     * @param userId The ID of the user to retrieve
     * @return UserResponse with user information, or null if not found
     */
    public UserResponse getUserById(UUID userId) {
        try {
            String url = USER_SERVICE_URL + "/users/" + userId;
            UserResponse userResponse = restTemplate.getForObject(url, UserResponse.class);

            if (userResponse != null) {
                log.debug("Retrieved user data for ID: {}", userId);
                return userResponse;
            }

            log.warn("User not found for ID: {}", userId);
            return null;
        } catch (Exception e) {
            log.error("Failed to get user data for ID: {}", userId, e);
            return null;
        }
    }

    /**
     * Retrieves customer email by customer ID.
     * 
     * @param customerId The ID of the customer
     * @return Customer email, or fallback placeholder if not found
     */
    public String getCustomerEmail(UUID customerId) {
        UserResponse userResponse = getUserById(customerId);
        if (userResponse != null) {
            return userResponse.getEmail();
        }

        // Fallback to placeholder for now
        log.warn("Using fallback email for customer ID: {}", customerId);
        return "customer-" + customerId.toString().substring(0, 8) + "@example.com";
    }

    /**
     * Retrieves driver email by driver ID.
     * 
     * @param driverId The ID of the driver
     * @return Driver email, or fallback placeholder if not found
     */
    public String getDriverEmail(UUID driverId) {
        UserResponse userResponse = getUserById(driverId);
        if (userResponse != null) {
            return userResponse.getEmail();
        }

        // Fallback to placeholder for now
        log.warn("Using fallback email for driver ID: {}", driverId);
        return "driver-" + driverId.toString().substring(0, 8) + "@example.com";
    }

    /**
     * Retrieves customer device token by customer ID.
     * 
     * @param customerId The ID of the customer
     * @return Customer device token, or fallback placeholder if not found
     */
    public String getCustomerDeviceToken(UUID customerId) {
        UserResponse userResponse = getUserById(customerId);
        if (userResponse != null) {
            return userResponse.getDeviceToken();
        }

        // Fallback to placeholder for now
        log.warn("Using fallback device token for customer ID: {}", customerId);
        return "device-token-" + customerId.toString().substring(0, 8);
    }
}
