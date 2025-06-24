package com.tracky.campaignservice.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class NotificationRequest {
    
    @JsonProperty("deviceToken")
    private String deviceToken;
    
    @JsonProperty("email")
    private String email;
    
    @JsonProperty("message")
    private String message;
    
    @JsonProperty("userName")
    private String userName;
}
