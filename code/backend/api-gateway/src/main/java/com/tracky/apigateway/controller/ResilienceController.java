package com.tracky.apigateway.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import io.github.resilience4j.circuitbreaker.CircuitBreakerRegistry;
import io.github.resilience4j.retry.RetryRegistry;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/actuator/resilience")
@RequiredArgsConstructor
public class ResilienceController {

    private final CircuitBreakerRegistry circuitBreakerRegistry;
    private final RetryRegistry retryRegistry;

    @GetMapping("/circuit-breakers")
    public Map<String, Object> getCircuitBreakers() {
        Map<String, Object> result = new HashMap<>();

        circuitBreakerRegistry.getAllCircuitBreakers().forEach(circuitBreaker -> {
            Map<String, Object> cbInfo = new HashMap<>();
            cbInfo.put("state", circuitBreaker.getState().toString());
            cbInfo.put("failureRate", circuitBreaker.getMetrics().getFailureRate());
            cbInfo.put("numberOfBufferedCalls", circuitBreaker.getMetrics().getNumberOfBufferedCalls());
            cbInfo.put("numberOfFailedCalls", circuitBreaker.getMetrics().getNumberOfFailedCalls());
            cbInfo.put("numberOfSuccessfulCalls", circuitBreaker.getMetrics().getNumberOfSuccessfulCalls());
            result.put(circuitBreaker.getName(), cbInfo);
        });

        return result;
    }

    @GetMapping("/retries")
    public Map<String, Object> getRetries() {
        Map<String, Object> result = new HashMap<>();

        retryRegistry.getAllRetries().forEach(retry -> {
            Map<String, Object> retryInfo = new HashMap<>();
            retryInfo.put("numberOfFailedCallsWithRetryAttempt",
                    retry.getMetrics().getNumberOfFailedCallsWithRetryAttempt());
            retryInfo.put("numberOfFailedCallsWithoutRetryAttempt",
                    retry.getMetrics().getNumberOfFailedCallsWithoutRetryAttempt());
            retryInfo.put("numberOfSuccessfulCallsWithRetryAttempt",
                    retry.getMetrics().getNumberOfSuccessfulCallsWithRetryAttempt());
            retryInfo.put("numberOfSuccessfulCallsWithoutRetryAttempt",
                    retry.getMetrics().getNumberOfSuccessfulCallsWithoutRetryAttempt());
            result.put(retry.getName(), retryInfo);
        });

        return result;
    }
}
