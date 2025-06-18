package com.tracky.apigateway.filter;

import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.factory.AbstractGatewayFilterFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;

import com.tracky.apigateway.security.JwtTokenValidator;

import reactor.core.publisher.Mono;

/**
 * JWT Authentication Filter for Spring Cloud Gateway.
 */
@Component
public class JwtAuthenticationFilter extends AbstractGatewayFilterFactory<JwtAuthenticationFilter.Config> {

    /**
     * JWT token validator used to validate and extract information from tokens.
     */
    @Autowired
    private JwtTokenValidator jwtTokenValidator;

    /**
     * Constructs a new JwtAuthenticationFilter.
     */
    public JwtAuthenticationFilter() {
        super(Config.class);
    }

    /**
     * Applies the JWT authentication filter to incoming requests.
     * 
     * @param config the filter configuration
     * @return a GatewayFilter that performs JWT authentication
     */
    @Override
    public GatewayFilter apply(Config config) {
        return (exchange, chain) -> {
            String path = exchange.getRequest().getURI().getPath();

            // Allow OPTIONS requests (CORS preflight) to pass through without JWT
            // validation
            if ("OPTIONS".equals(exchange.getRequest().getMethod().name())) {
                return chain.filter(exchange);
            }

            // Check if the path should be excluded from JWT validation
            if (config.getExcludePatterns() != null) {
                for (String excludePattern : config.getExcludePatterns()) {
                    if (path.equals(excludePattern)) {
                        return chain.filter(exchange);
                    }
                }
            }

            String authHeader = exchange.getRequest().getHeaders().getFirst(HttpHeaders.AUTHORIZATION);

            if (authHeader == null || !authHeader.startsWith("Bearer ")) {
                return unauthorized(exchange);
            }

            String token = authHeader.substring(7);

            if (!jwtTokenValidator.validateToken(token)) {
                return unauthorized(exchange);
            }

            // Add user email to headers for downstream services
            String email = jwtTokenValidator.getEmailFromJWT(token);
            ServerWebExchange modifiedExchange = exchange.mutate()
                    .request(exchange.getRequest().mutate()
                            .header("X-User-Email", email)
                            .build())
                    .build();

            return chain.filter(modifiedExchange);
        };
    }

    /**
     * Returns an unauthorized response.
     * 
     * @param exchange the current server web exchange
     * @return a Mono completing with void when the response has been written
     */
    private Mono<Void> unauthorized(ServerWebExchange exchange) {
        exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
        return exchange.getResponse().setComplete();
    }

    /**
     * Configuration class for the JWT Authentication Filter.
     * Holds configuration properties like paths to exclude from authentication.
     */
    public static class Config {
        /**
         * List of path patterns to exclude from JWT authentication.
         */
        private List<String> excludePatterns;

        /**
         * Gets the list of path patterns excluded from JWT authentication.
         * 
         * @return list of excluded path patterns
         */
        public List<String> getExcludePatterns() {
            return excludePatterns;
        }

        /**
         * Sets the list of path patterns to exclude from JWT authentication.
         * Input string is split by commas to create the list.
         * 
         * @param excludePatterns comma-separated list of path patterns
         */
        public void setExcludePatterns(String excludePatterns) {
            this.excludePatterns = Arrays.asList(excludePatterns.split(","));
        }
    }
}
