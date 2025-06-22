package com.tracky.campaignservice.dto;

import java.time.LocalDateTime;
import java.util.UUID;

import com.tracky.campaignservice.model.Campaign;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Response DTO for campaign information.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CampaignResponse {

    /**
     * Unique identifier for the campaign.
     */
    private UUID id;

    /**
     * Message content of the campaign.
     */
    private String message;

    /**
     * Target user type for the campaign.
     */
    private Campaign.UserType userType;

    /**
     * Number of users reached by this campaign.
     */
    private Integer usersReached;

    /**
     * Status of the campaign.
     */
    private Campaign.CampaignStatus status;

    /**
     * Timestamp when the campaign was created.
     */
    private LocalDateTime createdAt;

    /**
     * Timestamp when the campaign was last updated.
     */
    private LocalDateTime updatedAt;
}
