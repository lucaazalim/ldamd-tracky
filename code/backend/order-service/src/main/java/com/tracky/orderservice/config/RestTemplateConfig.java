package com.tracky.orderservice.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

/**
 * Configuration class for RestTemplate.
 * Provides a configured RestTemplate bean for making HTTP requests to external
 * services,
 * such as the Google Maps API.
 */
@Configuration
public class RestTemplateConfig {

    /**
     * Creates and configures the RestTemplate bean.
     * 
     * @return a configured RestTemplate instance
     */
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
}
