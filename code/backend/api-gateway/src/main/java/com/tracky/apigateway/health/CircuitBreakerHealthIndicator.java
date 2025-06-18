package com.tracky.apigateway.health;

import java.util.HashMap;
import java.util.Map;

import org.springframework.boot.actuate.health.Health;
import org.springframework.boot.actuate.health.HealthIndicator;
import org.springframework.stereotype.Component;

import io.github.resilience4j.circuitbreaker.CircuitBreaker;
import io.github.resilience4j.circuitbreaker.CircuitBreakerRegistry;
import lombok.RequiredArgsConstructor;

/**
 * Health indicator for circuit breakers in the API Gateway.
 * Reports the health status of all circuit breakers to Spring Boot Actuator's
 * health endpoint.
 * If any circuit breaker is in the OPEN state, the overall health status will
 * be DOWN.
 */
@Component("circuitBreakers")
@RequiredArgsConstructor
public class CircuitBreakerHealthIndicator implements HealthIndicator {

    /**
     * Registry that manages all circuit breakers in the application.
     */
    private final CircuitBreakerRegistry circuitBreakerRegistry;

    /**
     * Determines the health status based on circuit breaker states.
     * Aggregates metrics and states from all circuit breakers and returns
     * an overall health status with detailed information.
     * 
     * @return Health object indicating UP if all circuit breakers are healthy,
     *         or DOWN if any circuit breaker is in the OPEN state
     */
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
