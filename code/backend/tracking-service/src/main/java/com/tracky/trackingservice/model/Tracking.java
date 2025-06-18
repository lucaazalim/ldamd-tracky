package com.tracky.trackingservice.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

import org.hibernate.annotations.CreationTimestamp;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Entity representing a tracking record for an order's location.
 */
@Entity
@Table(name = "tracking")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Tracking {

    /**
     * Unique identifier for the tracking record.
     */
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    /**
     * Reference to the order being tracked.
     */
    @NotNull(message = "Order ID is required")
    @Column(name = "order_id", nullable = false)
    private UUID orderId;

    /**
     * Geographic latitude coordinate of the order's current location.
     */
    @NotNull(message = "Latitude is required")
    @Column(nullable = false, precision = 10, scale = 8)
    private BigDecimal latitude;

    /**
     * Geographic longitude coordinate of the order's current location.
     */
    @NotNull(message = "Longitude is required")
    @Column(nullable = false, precision = 11, scale = 8)
    private BigDecimal longitude;

    /**
     * Timestamp when the tracking record was created.
     */
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    /**
     * Creates a new tracking record with location data for an order.
     * 
     * @param orderId The ID of the order being tracked
     * @param latitude The current latitude coordinate
     * @param longitude The current longitude coordinate
     */
    public Tracking(UUID orderId, BigDecimal latitude, BigDecimal longitude) {
        this.orderId = orderId;
        this.latitude = latitude;
        this.longitude = longitude;
    }
}
