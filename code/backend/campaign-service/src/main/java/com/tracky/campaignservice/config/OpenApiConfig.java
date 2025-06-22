package com.tracky.campaignservice.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI campaignServiceOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("Campaign Service API")
                        .description("API for managing campaigns in Tracky system")
                        .version("v1.0"));
    }
}
