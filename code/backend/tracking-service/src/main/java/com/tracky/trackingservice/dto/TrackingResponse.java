package com.tracky.trackingservice.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

import com.tracky.trackingservice.model.Tracking;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Data Transfer Object for tracking information responses.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class TrackingResponse {

    /**
     * Unique identifier of the tracking record.
     */
    private UUID id;
    
    /**
     * The ID of the order being tracked.
     */
    private UUID orderId;
    
    /**
     * The latitude coordinate of the order's location.
     */
    private BigDecimal latitude;
    
    /**
     * The longitude coordinate of the order's location.
     */
    private BigDecimal longitude;
    
    /**
     * When the tracking record was created.
     */
    private LocalDateTime createdAt;

    /**
     * Creates a TrackingResponse from a Tracking entity.
     * 
     * @param tracking The tracking entity to convert
     * @return A TrackingResponse object with tracking information
     */
    public static TrackingResponse fromTracking(Tracking tracking) {
        return new TrackingResponse(
                tracking.getId(),
                tracking.getOrderId(),
                tracking.getLatitude(),
                tracking.getLongitude(),
                tracking.getCreatedAt());
    }
}
