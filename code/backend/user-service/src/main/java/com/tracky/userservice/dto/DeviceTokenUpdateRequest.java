package com.tracky.userservice.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Data Transfer Object for device token update requests.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class DeviceTokenUpdateRequest {

    /**
     * Device token for push notifications.
     */
    @NotBlank(message = "Device token is required")
    private String deviceToken;
}
