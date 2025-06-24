package com.tracky.notificationservice.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CampaignNotificationRequest {
    
    @JsonProperty("deviceToken")
    private String deviceToken;
    
    @JsonProperty("email")
    private String email;
    
    @JsonProperty("message")
    private String message;
    
    @JsonProperty("userName")
    private String userName;
}
