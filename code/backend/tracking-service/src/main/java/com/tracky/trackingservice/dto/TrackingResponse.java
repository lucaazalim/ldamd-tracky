package com.tracky.trackingservice.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

import com.tracky.trackingservice.model.Tracking;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class TrackingResponse {

    private UUID id;
    private UUID orderId;
    private BigDecimal latitude;
    private BigDecimal longitude;
    private LocalDateTime createdAt;

    public static TrackingResponse fromTracking(Tracking tracking) {
        return new TrackingResponse(
                tracking.getId(),
                tracking.getOrderId(),
                tracking.getLatitude(),
                tracking.getLongitude(),
                tracking.getCreatedAt());
    }
}
