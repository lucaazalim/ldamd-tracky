package com.tracky.notificationservice.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO for campaign notification request.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CampaignNotificationRequest {

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
