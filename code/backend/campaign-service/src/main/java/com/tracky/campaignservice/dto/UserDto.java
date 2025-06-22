package com.tracky.campaignservice.dto;

import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO for user information from user service.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserDto {

    /**
     * Unique identifier for the user.
     */
    private UUID id;

    /**
     * Full name of the user.
     */
    private String name;

    /**
     * Email address of the user.
     */
    private String email;

    /**
     * Type of user (customer or driver).
     */
    private String type;

    /**
     * Device token for push notifications (FCM token).
     */
    private String deviceToken;
}
