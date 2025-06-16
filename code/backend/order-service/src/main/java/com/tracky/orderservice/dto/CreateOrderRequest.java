package com.tracky.orderservice.dto;

import java.util.UUID;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public class CreateOrderRequest {

    @NotNull(message = "Customer ID is required")
    private UUID customerId;

    @NotBlank(message = "Origin address is required")
    private String originAddress;

    @NotBlank(message = "Destination address is required")
    private String destinationAddress;

    @NotBlank(message = "Description is required")
    private String description;

    private String imageUrl;

    // Constructors
    public CreateOrderRequest() {
    }

    public CreateOrderRequest(UUID customerId, String originAddress, String destinationAddress, String description,
            String imageUrl) {
        this.customerId = customerId;
        this.originAddress = originAddress;
        this.destinationAddress = destinationAddress;
        this.description = description;
        this.imageUrl = imageUrl;
    }

    // Getters and Setters
    public UUID getCustomerId() {
        return customerId;
    }

    public void setCustomerId(UUID customerId) {
        this.customerId = customerId;
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
}
