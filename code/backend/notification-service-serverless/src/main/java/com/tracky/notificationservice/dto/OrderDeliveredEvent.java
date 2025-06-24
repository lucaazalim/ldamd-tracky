package com.tracky.notificationservice.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrderDeliveredEvent {
    
    @JsonProperty("orderId")
    private String orderId;
    
    @JsonProperty("customerId")
    private String customerId;
    
    @JsonProperty("driverId")
    private String driverId;
    
    @JsonProperty("description")
    private String description;
    
    @JsonProperty("originAddress")
    private String originAddress;
    
    @JsonProperty("destinationAddress")
    private String destinationAddress;
    
    @JsonProperty("deliveredAt")
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime deliveredAt;
}
