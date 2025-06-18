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

/**
 * Entity class representing an order in the system.
 * An order contains information about a delivery request including origin,
 * destination,
 * customer details, driver assignment, and current status.
 */
@Entity
@Table(name = "orders")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Order {

    /**
     * Unique identifier for the order.
     */
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    /**
     * Identifier of the customer who placed the order.
     */
    @NotNull(message = "Customer ID is required")
    @Column(name = "customer_id", nullable = false)
    private UUID customerId;

    /**
     * Identifier of the driver assigned to the order.
     * Can be null if no driver has been assigned yet.
     */
    @Column(name = "driver_id")
    private UUID driverId;

    /**
     * Current status of the order (PENDING, ACCEPTED, ON_COURSE, DELIVERED).
     */
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private OrderStatus status = OrderStatus.PENDING;

    /**
     * Address where the package should be picked up from.
     */
    @NotBlank(message = "Origin address is required")
    @Column(name = "origin_address", nullable = false)
    private String originAddress;

    /**
     * Address where the package should be delivered to.
     */
    @NotBlank(message = "Destination address is required")
    @Column(name = "destination_address", nullable = false)
    private String destinationAddress;

    /**
     * Description of the package or delivery.
     */
    @NotBlank(message = "Description is required")
    @Column(nullable = false)
    private String description;

    /**
     * Optional URL to an image of the package.
     */
    @Column(name = "image_url")
    private String imageUrl;

    /**
     * Timestamp when the order was created.
     * This field is automatically set by Hibernate.
     */
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    /**
     * Timestamp when the order was last updated.
     * This field is automatically updated by Hibernate.
     */
    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    /**
     * Enum representing the possible states of an order.
     */
    public enum OrderStatus {
        /**
         * Order has been created but not yet assigned to a driver.
         */
        PENDING,

        /**
         * Order has been accepted by a driver.
         */
        ACCEPTED,

        /**
         * Driver is en route to deliver the order.
         */
        ON_COURSE,

        /**
         * Order has been successfully delivered.
         */
        DELIVERED
    }

    /**
     * Custom constructor for creating orders without timestamps (they are
     * auto-generated).
     * 
     * @param customerId         ID of the customer placing the order
     * @param originAddress      address where the package should be picked up
     * @param destinationAddress address where the package should be delivered
     * @param description        description of the package or delivery
     */
    public Order(UUID customerId, String originAddress, String destinationAddress, String description) {
        this.customerId = customerId;
        this.originAddress = originAddress;
        this.destinationAddress = destinationAddress;
        this.description = description;
    }
}
