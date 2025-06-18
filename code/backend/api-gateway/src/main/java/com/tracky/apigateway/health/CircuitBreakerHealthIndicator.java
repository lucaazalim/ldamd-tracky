package com.tracky.apigateway.health;

import java.util.HashMap;
import java.util.Map;

import org.springframework.boot.actuate.health.Health;
import org.springframework.boot.actuate.health.HealthIndicator;
import org.springframework.stereotype.Component;

import io.github.resilience4j.circuitbreaker.CircuitBreaker;
import io.github.resilience4j.circuitbreaker.CircuitBreakerRegistry;
import lombok.RequiredArgsConstructor;

@Component("circuitBreakers")
@RequiredArgsConstructor
public class CircuitBreakerHealthIndicator implements HealthIndicator {

    private final CircuitBreakerRegistry circuitBreakerRegistry;

    @Override
    public Health health() {
        Map<String, Object> details = new HashMap<>();
        boolean allHealthy = true;

        for (CircuitBreaker circuitBreaker : circuitBreakerRegistry.getAllCircuitBreakers()) {
            CircuitBreaker.State state = circuitBreaker.getState();
            Map<String, Object> cbDetails = new HashMap<>();

            cbDetails.put("state", state.toString());
            cbDetails.put("failureRate", circuitBreaker.getMetrics().getFailureRate());
            cbDetails.put("numberOfBufferedCalls", circuitBreaker.getMetrics().getNumberOfBufferedCalls());
            cbDetails.put("numberOfFailedCalls", circuitBreaker.getMetrics().getNumberOfFailedCalls());
            cbDetails.put("numberOfSuccessfulCalls", circuitBreaker.getMetrics().getNumberOfSuccessfulCalls());

            details.put(circuitBreaker.getName(), cbDetails);

            // Circuit breaker is unhealthy if it's open
            if (state == CircuitBreaker.State.OPEN) {
                allHealthy = false;
            }
        }

        return allHealthy ? Health.up().withDetails(details).build() : Health.down().withDetails(details).build();
    }
}
