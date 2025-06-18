package com.tracky.trackingservice.dto;

import java.math.BigDecimal;
import java.util.UUID;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Data Transfer Object for creating new tracking updates.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TrackingUpdateRequest {

    /**
     * The ID of the order being tracked.
     */
    @NotNull(message = "Order ID is required")
    private UUID orderId;

    /**
     * The current latitude coordinate of the order.
     */
    @NotNull(message = "Latitude is required")
    private BigDecimal latitude;

    /**
     * The current longitude coordinate of the order.
     */
    @NotNull(message = "Longitude is required")
    private BigDecimal longitude;
}
