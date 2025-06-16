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

@Entity
@Table(name = "tracking")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Tracking {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @NotNull(message = "Order ID is required")
    @Column(name = "order_id", nullable = false)
    private UUID orderId;

    @NotNull(message = "Latitude is required")
    @Column(nullable = false, precision = 10, scale = 8)
    private BigDecimal latitude;

    @NotNull(message = "Longitude is required")
    @Column(nullable = false, precision = 11, scale = 8)
    private BigDecimal longitude;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    // Custom constructor for creating tracking without timestamp (it's
    // auto-generated)
    public Tracking(UUID orderId, BigDecimal latitude, BigDecimal longitude) {
        this.orderId = orderId;
        this.latitude = latitude;
        this.longitude = longitude;
    }
}
