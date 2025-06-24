package com.tracky.campaignservice.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CampaignRequest {

    @NotBlank(message = "Message is required")
    @JsonProperty("message")
    private String message;

    @NotBlank(message = "User type is required")
    @JsonProperty("userType")
    private String userType;
}
