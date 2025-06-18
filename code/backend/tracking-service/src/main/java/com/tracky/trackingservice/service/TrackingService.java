package com.tracky.trackingservice.service;

import com.tracky.trackingservice.dto.TrackingResponse;
import com.tracky.trackingservice.dto.TrackingUpdateRequest;
import com.tracky.trackingservice.model.Tracking;
import com.tracky.trackingservice.repository.TrackingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.UUID;

/**
 * Service for managing order tracking operations.
 */
@Service
public class TrackingService {

    /**
     * Repository for tracking data access.
     */
    @Autowired
    private TrackingRepository trackingRepository;

    /**
     * Creates a new tracking update for an order.
     *
     * @param request The tracking update data with order ID and coordinates
     * @return Tracking information response
     */
    public TrackingResponse createTrackingUpdate(TrackingUpdateRequest request) {
        Tracking tracking = new Tracking();
        tracking.setOrderId(request.getOrderId());
        tracking.setLatitude(request.getLatitude());
        tracking.setLongitude(request.getLongitude());

        Tracking savedTracking = trackingRepository.save(tracking);
        return TrackingResponse.fromTracking(savedTracking);
    }

    /**
     * Retrieves the latest tracking information for an order.
     *
     * @param orderId The ID of the order to retrieve tracking for
     * @return The latest tracking information for the order
     * @throws RuntimeException If no tracking is found for the order
     */
    public TrackingResponse getLatestTrackingByOrderId(UUID orderId) {
        Tracking tracking = trackingRepository.findLatestByOrderId(orderId)
                .orElseThrow(() -> new RuntimeException("No tracking information found for order"));

        return TrackingResponse.fromTracking(tracking);
    }
}
