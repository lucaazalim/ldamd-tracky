package com.tracky.trackingservice.dto;

import com.tracky.trackingservice.model.Tracking;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

public class TrackingResponse {

    private UUID id;
    private UUID orderId;
    private BigDecimal latitude;
    private BigDecimal longitude;
    private LocalDateTime createdAt;

    // Constructors
    public TrackingResponse() {
    }

    public TrackingResponse(UUID id, UUID orderId, BigDecimal latitude, BigDecimal longitude, LocalDateTime createdAt) {
        this.id = id;
        this.orderId = orderId;
        this.latitude = latitude;
        this.longitude = longitude;
        this.createdAt = createdAt;
    }

    public static TrackingResponse fromTracking(Tracking tracking) {
        return new TrackingResponse(
                tracking.getId(),
                tracking.getOrderId(),
                tracking.getLatitude(),
                tracking.getLongitude(),
                tracking.getCreatedAt());
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

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

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
