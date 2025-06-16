package com.tracky.trackingservice.dto;

import jakarta.validation.constraints.NotNull;

import java.math.BigDecimal;
import java.util.UUID;

public class TrackingUpdateRequest {

    @NotNull(message = "Order ID is required")
    private UUID orderId;

    @NotNull(message = "Latitude is required")
    private BigDecimal latitude;

    @NotNull(message = "Longitude is required")
    private BigDecimal longitude;

    // Constructors
    public TrackingUpdateRequest() {
    }

    public TrackingUpdateRequest(UUID orderId, BigDecimal latitude, BigDecimal longitude) {
        this.orderId = orderId;
        this.latitude = latitude;
        this.longitude = longitude;
    }

    // Getters and Setters
    public UUID getOrderId() {
        return orderId;
    }

    public void setOrderId(UUID orderId) {
        this.orderId = orderId;
    }

    public BigDecimal getLatitude() {
        return latitude;
    }

    public void setLatitude(BigDecimal latitude) {
        this.latitude = latitude;
    }

    public BigDecimal getLongitude() {
        return longitude;
    }

    public void setLongitude(BigDecimal longitude) {
        this.longitude = longitude;
    }
}
