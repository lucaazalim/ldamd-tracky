package com.tracky.userservice.dto;

import java.util.UUID;

import com.tracky.userservice.model.User;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Data Transfer Object for user information responses.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserResponse {

    /**
     * Unique identifier of the user.
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
     * Type of the user (customer or driver).
     */
    private User.UserType type;

    /**
     * Device token for push notifications.
     */
    private String deviceToken;

    /**
     * Creates a UserResponse from a User entity.
     * 
     * @param user The user entity to convert
     * @return A UserResponse object with basic user information
     */
    public static UserResponse fromUser(User user) {
        return new UserResponse(user.getId(), user.getName(), user.getEmail(), user.getType(), user.getDeviceToken());
    }
}
