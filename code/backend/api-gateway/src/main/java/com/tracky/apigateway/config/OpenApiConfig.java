package com.tracky.apigateway.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;

/**
 * Configuration class for OpenAPI documentation.
 * Sets up Swagger UI for API documentation of the gateway service.
 */
@Configuration
public class OpenApiConfig {

    /**
     * Creates and configures the OpenAPI bean for API documentation.
     * 
     * @return a configured OpenAPI instance with information about the API Gateway
     */
    @Bean
    public OpenAPI apiGatewayOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("Tracky API Gateway")
                        .description("Central API Gateway for Tracky Microservices")
                        .version("1.0.0")
                        .contact(new Contact()
                                .name("Tracky Team")
                                .email("support@tracky.com")));
    }
}
