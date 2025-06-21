package com.tracky.orderservice.event;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

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
