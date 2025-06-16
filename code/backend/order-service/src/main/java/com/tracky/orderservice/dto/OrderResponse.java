package com.tracky.orderservice.dto;

import java.time.LocalDateTime;
import java.util.UUID;

import com.tracky.orderservice.model.Order;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrderResponse {

    private UUID id;
    private UUID customerId;
    private UUID driverId;
    private Order.OrderStatus status;
    private String originAddress;
    private String destinationAddress;
    private String description;
    private String imageUrl;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static OrderResponse fromOrder(Order order) {
        return new OrderResponse(
                order.getId(),
                order.getCustomerId(),
                order.getDriverId(),
                order.getStatus(),
                order.getOriginAddress(),
                order.getDestinationAddress(),
                order.getDescription(),
                order.getImageUrl(),
                order.getCreatedAt(),
                order.getUpdatedAt());
    }
}
