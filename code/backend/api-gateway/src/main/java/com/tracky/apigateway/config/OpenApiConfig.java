package com.tracky.apigateway.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;

@Configuration
public class OpenApiConfig {

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
