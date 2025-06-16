package com.tracky.trackingservice.service;

import com.tracky.trackingservice.dto.TrackingResponse;
import com.tracky.trackingservice.dto.TrackingUpdateRequest;
import com.tracky.trackingservice.model.Tracking;
import com.tracky.trackingservice.repository.TrackingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class TrackingService {

    @Autowired
    private TrackingRepository trackingRepository;

    public TrackingResponse createTrackingUpdate(TrackingUpdateRequest request) {
        Tracking tracking = new Tracking();
        tracking.setOrderId(request.getOrderId());
        tracking.setLatitude(request.getLatitude());
        tracking.setLongitude(request.getLongitude());

        Tracking savedTracking = trackingRepository.save(tracking);
        return TrackingResponse.fromTracking(savedTracking);
    }

    public TrackingResponse getLatestTrackingByOrderId(UUID orderId) {
        Tracking tracking = trackingRepository.findLatestByOrderId(orderId)
                .orElseThrow(() -> new RuntimeException("No tracking information found for order"));

        return TrackingResponse.fromTracking(tracking);
    }
}
