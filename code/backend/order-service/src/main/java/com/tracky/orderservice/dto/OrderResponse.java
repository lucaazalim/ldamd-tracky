package com.tracky.orderservice.dto;

import java.time.LocalDateTime;
import java.util.UUID;

import com.tracky.orderservice.model.Order;

public class OrderResponse {

    private UUID id;
    private UUID customerId;
    private UUID driverId;
    private Order.OrderStatus status;
    private String originAddress;
    private String destinationAddress;
    private String description;
    private String imageUrl;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Constructors
    public OrderResponse() {
    }

    public OrderResponse(UUID id, UUID customerId, UUID driverId, Order.OrderStatus status,
            String originAddress, String destinationAddress, String description, String imageUrl,
            LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.id = id;
        this.customerId = customerId;
        this.driverId = driverId;
        this.status = status;
        this.originAddress = originAddress;
        this.destinationAddress = destinationAddress;
        this.description = description;
        this.imageUrl = imageUrl;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public static OrderResponse fromOrder(Order order) {
        return new OrderResponse(
                order.getId(),
                order.getCustomerId(),
                order.getDriverId(),
                order.getStatus(),
                order.getOriginAddress(),
                order.getDestinationAddress(),
                order.getDescription(),
                order.getImageUrl(),
                order.getCreatedAt(),
                order.getUpdatedAt());
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getCustomerId() {
        return customerId;
    }

    public void setCustomerId(UUID customerId) {
        this.customerId = customerId;
    }

    public UUID getDriverId() {
        return driverId;
    }

    public void setDriverId(UUID driverId) {
        this.driverId = driverId;
    }

    public Order.OrderStatus getStatus() {
        return status;
    }

    public void setStatus(Order.OrderStatus status) {
        this.status = status;
    }

    public String getOriginAddress() {
        return originAddress;
    }

    public void setOriginAddress(String originAddress) {
        this.originAddress = originAddress;
    }

    public String getDestinationAddress() {
        return destinationAddress;
    }

    public void setDestinationAddress(String destinationAddress) {
        this.destinationAddress = destinationAddress;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
