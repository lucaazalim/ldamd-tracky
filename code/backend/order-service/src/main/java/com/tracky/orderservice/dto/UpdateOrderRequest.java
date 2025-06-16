package com.tracky.orderservice.dto;

import com.tracky.orderservice.model.Order;

import java.util.UUID;

public class UpdateOrderRequest {

    private UUID driverId;
    private Order.OrderStatus status;
    private String address;
    private String description;
    private String imageUrl;

    // Constructors
    public UpdateOrderRequest() {
    }

    // Getters and Setters
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

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
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
}
