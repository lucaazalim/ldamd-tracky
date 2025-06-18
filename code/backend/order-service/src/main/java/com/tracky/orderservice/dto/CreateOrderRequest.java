package com.tracky.orderservice.dto;

import java.util.UUID;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Data Transfer Object (DTO) for creating a new order.
 * Contains all the required information to create an order in the system.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class CreateOrderRequest {

    /**
     * The ID of the customer creating the order.
     * This field is required.
     */
    @NotNull(message = "Customer ID is required")
    private UUID customerId;

    /**
     * The address where the package should be picked up from.
     * This field is required.
     */
    @NotBlank(message = "Origin address is required")
    private String originAddress;

    /**
     * The address where the package should be delivered to.
     * This field is required.
     */
    @NotBlank(message = "Destination address is required")
    private String destinationAddress;

    /**
     * Description of the package or delivery.
     * This field is required.
     */
    @NotBlank(message = "Description is required")
    private String description;

    /**
     * Optional URL to an image of the package.
     */
    private String imageUrl;
}
