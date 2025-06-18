package com.tracky.apigateway.controller;

import java.time.LocalDateTime;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/fallback")
@Slf4j
public class FallbackController {

    @GetMapping("/user-service")
    @PostMapping("/user-service")
    @PutMapping("/user-service")
    @DeleteMapping("/user-service")
    public ResponseEntity<Map<String, Object>> userServiceFallback() {
        log.warn("User Service is currently unavailable - Circuit breaker activated");
        return createFallbackResponse("User Service",
                "User management operations are temporarily unavailable. Please try again later.");
    }

    @GetMapping("/order-service")
    @PostMapping("/order-service")
    @PutMapping("/order-service")
    @DeleteMapping("/order-service")
    public ResponseEntity<Map<String, Object>> orderServiceFallback() {
        log.warn("Order Service is currently unavailable - Circuit breaker activated");
        return createFallbackResponse("Order Service",
                "Order operations are temporarily unavailable. Please try again later.");
    }

    @GetMapping("/tracking-service")
    @PostMapping("/tracking-service")
    @PutMapping("/tracking-service")
    @DeleteMapping("/tracking-service")
    public ResponseEntity<Map<String, Object>> trackingServiceFallback() {
        log.warn("Tracking Service is currently unavailable - Circuit breaker activated");
        return createFallbackResponse("Tracking Service",
                "Tracking operations are temporarily unavailable. Please try again later.");
    }

    private ResponseEntity<Map<String, Object>> createFallbackResponse(String serviceName, String message) {
        Map<String, Object> response = Map.of(
                "error", "Service Unavailable",
                "message", message,
                "service", serviceName,
                "timestamp", LocalDateTime.now(),
                "status", HttpStatus.SERVICE_UNAVAILABLE.value(),
                "fallback", true);
        return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(response);
    }
}
