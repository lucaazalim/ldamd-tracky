package com.tracky.orderservice.dto;

import java.time.LocalDateTime;
import java.util.UUID;

import com.tracky.orderservice.model.Order;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Data Transfer Object (DTO) for returning order information to clients.
 * Contains all details about an order, including its current state and
 * timestamps.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrderResponse {

    /**
     * Unique identifier of the order.
     */
    private UUID id;

    /**
     * ID of the customer who placed the order.
     */
    private UUID customerId;

    /**
     * ID of the driver assigned to the order, can be null if unassigned.
     */
    private UUID driverId;

    /**
     * Current status of the order.
     */
    private Order.OrderStatus status;

    /**
     * Address where the package should be picked up from.
     */
    private String originAddress;

    /**
     * Address where the package should be delivered to.
     */
    private String destinationAddress;

    /**
     * Description of the package or delivery.
     */
    private String description;

    /**
     * URL to an image of the package, if available.
     */
    private String imageUrl;

    /**
     * Timestamp when the order was created.
     */
    private LocalDateTime createdAt;

    /**
     * Timestamp when the order was last updated.
     */
    private LocalDateTime updatedAt;

    /**
     * Static factory method to create an OrderResponse from an Order entity.
     * 
     * @param order the Order entity to convert
     * @return a new OrderResponse populated with the order's data
     */
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
