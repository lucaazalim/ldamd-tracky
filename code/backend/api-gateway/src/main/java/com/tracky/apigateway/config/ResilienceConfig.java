package com.tracky.apigateway.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import io.github.resilience4j.circuitbreaker.CircuitBreakerRegistry;
import io.github.resilience4j.retry.RetryRegistry;
import lombok.extern.slf4j.Slf4j;

/**
 * Configuration class for resilience patterns in the API Gateway.
 * Sets up circuit breakers and retry mechanisms to handle failures gracefully.
 */
@Configuration
@Slf4j
public class ResilienceConfig {

    /**
     * Creates and configures the Circuit Breaker Registry.
     * Circuit breakers help prevent cascading failures by stopping calls to failing
     * services.
     * 
     * @return a configured CircuitBreakerRegistry with default settings
     */
    @Bean
    public CircuitBreakerRegistry circuitBreakerRegistry() {
        log.info("Initializing Circuit Breaker Registry");
        return CircuitBreakerRegistry.ofDefaults();
    }

    /**
     * Creates and configures the Retry Registry.
     * Retry mechanisms allow failed calls to be retried automatically with
     * configurable backoff.
     * 
     * @return a configured RetryRegistry with default settings
     */
    @Bean
    public RetryRegistry retryRegistry() {
        log.info("Initializing Retry Registry");
        return RetryRegistry.ofDefaults();
    }
}
