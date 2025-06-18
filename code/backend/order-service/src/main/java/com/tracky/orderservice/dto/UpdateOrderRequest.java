package com.tracky.orderservice.dto;

import java.util.UUID;

import com.tracky.orderservice.model.Order;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Data Transfer Object (DTO) for updating an existing order.
 * All fields are optional, allowing partial updates of order information.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class UpdateOrderRequest {

    /**
     * ID of the driver to assign to the order. Can be null to unassign.
     */
    private UUID driverId;

    /**
     * New status to update the order to.
     */
    private Order.OrderStatus status;

    /**
     * New origin address for the order.
     */
    private String originAddress;

    /**
     * New destination address for the order.
     */
    private String destinationAddress;

    /**
     * Updated description of the package or delivery.
     */
    private String description;

    /**
     * Updated image URL for the order.
     */
    private String imageUrl;
}
