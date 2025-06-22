package com.tracky.campaignservice.dto;

import com.tracky.campaignservice.model.Campaign;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Request DTO for creating a new campaign.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CampaignRequest {

    /**
     * Message content of the campaign.
     */
    @NotBlank(message = "Message is required")
    private String message;

    /**
     * Target user type for the campaign.
     */
    @NotNull(message = "User type is required")
    private Campaign.UserType userType;
}
