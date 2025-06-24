package com.tracky.campaignservice.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.tracky.campaignservice.model.Campaign;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CampaignResponse {
    
    @JsonProperty("id")
    private String id;
    
    @JsonProperty("message")
    private String message;
    
    @JsonProperty("userType")
    private String userType;
    
    @JsonProperty("usersReached")
    private Integer usersReached;
    
    @JsonProperty("status")
    private Campaign.CampaignStatus status;
    
    @JsonProperty("createdAt")
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime createdAt;
    
    @JsonProperty("updatedAt")
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime updatedAt;
}
