package com.tracky.userservice.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Data Transfer Object for user update requests.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserUpdateRequest {

    /**
     * Device token for push notifications.
     */
    private String deviceToken;
}
