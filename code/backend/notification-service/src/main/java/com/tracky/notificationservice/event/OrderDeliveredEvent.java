package com.tracky.notificationservice.event;

import java.time.LocalDateTime;
import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrderDeliveredEvent {
    private UUID orderId;
    private UUID customerId;
    private UUID driverId;
    private String originAddress;
    private String destinationAddress;
    private String description;
    private LocalDateTime deliveredAt;
}
