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

@Component
public class JwtAuthenticationFilter extends AbstractGatewayFilterFactory<JwtAuthenticationFilter.Config> {

    @Autowired
    private JwtTokenValidator jwtTokenValidator;

    public JwtAuthenticationFilter() {
        super(Config.class);
    }

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

    private Mono<Void> unauthorized(ServerWebExchange exchange) {
        exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
        return exchange.getResponse().setComplete();
    }

    public static class Config {
        private List<String> excludePatterns;

        public List<String> getExcludePatterns() {
            return excludePatterns;
        }

        public void setExcludePatterns(String excludePatterns) {
            this.excludePatterns = Arrays.asList(excludePatterns.split(","));
        }
    }
}
