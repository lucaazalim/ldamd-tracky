package com.tracky.orderservice.dto;

import java.util.UUID;

import com.tracky.orderservice.model.Order;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UpdateOrderRequest {

    private UUID driverId;
    private Order.OrderStatus status;
    private String originAddress;
    private String destinationAddress;
    private String description;
    private String imageUrl;
}
