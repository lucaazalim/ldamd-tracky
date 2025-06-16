package com.tracky.trackingservice.controller;

import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.tracky.trackingservice.dto.TrackingResponse;
import com.tracky.trackingservice.dto.TrackingUpdateRequest;
import com.tracky.trackingservice.service.TrackingService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;

@RestController
@RequestMapping("/tracking")
@Tag(name = "Tracking Management", description = "APIs for order tracking")
public class TrackingController {

    @Autowired
    private TrackingService trackingService;

    @PostMapping
    @Operation(summary = "Create tracking update", description = "Add new tracking location for an order")
    public ResponseEntity<TrackingResponse> createTrackingUpdate(@Valid @RequestBody TrackingUpdateRequest request) {
        try {
            TrackingResponse response = trackingService.createTrackingUpdate(request);
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @GetMapping("/{orderId}/latest")
    @Operation(summary = "Get latest tracking", description = "Get the latest tracking information for an order")
    public ResponseEntity<TrackingResponse> getLatestTracking(@PathVariable UUID orderId) {
        try {
            TrackingResponse response = trackingService.getLatestTrackingByOrderId(orderId);
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }
}
