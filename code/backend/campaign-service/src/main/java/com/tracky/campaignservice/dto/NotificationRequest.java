package com.tracky.campaignservice.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO for notification request to be sent to RabbitMQ.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class NotificationRequest {

    /**
     * Device token for push notification.
     */
    private String deviceToken;

    /**
     * Email address for email notification.
     */
    private String email;

    /**
     * Message to be sent.
     */
    private String message;

    /**
     * User's name for personalization.
     */
    private String userName;
}
