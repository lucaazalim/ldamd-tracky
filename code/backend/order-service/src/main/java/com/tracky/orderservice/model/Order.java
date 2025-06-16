package com.tracky.orderservice.model;

import java.time.LocalDateTime;
import java.util.UUID;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "orders")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @NotNull(message = "Customer ID is required")
    @Column(name = "customer_id", nullable = false)
    private UUID customerId;

    @Column(name = "driver_id")
    private UUID driverId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private OrderStatus status = OrderStatus.PENDING;

    @NotBlank(message = "Origin address is required")
    @Column(name = "origin_address", nullable = false)
    private String originAddress;

    @NotBlank(message = "Destination address is required")
    @Column(name = "destination_address", nullable = false)
    private String destinationAddress;

    @NotBlank(message = "Description is required")
    @Column(nullable = false)
    private String description;

    @Column(name = "image_url")
    private String imageUrl;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    public enum OrderStatus {
        PENDING, ACCEPTED, ON_COURSE, DELIVERED
    }

    // Custom constructor for creating orders without timestamps (they are
    // auto-generated)
    public Order(UUID customerId, String originAddress, String destinationAddress, String description) {
        this.customerId = customerId;
        this.originAddress = originAddress;
        this.destinationAddress = destinationAddress;
        this.description = description;
    }
}
