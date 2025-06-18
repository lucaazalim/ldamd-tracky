package com.tracky.apigateway.security;

import javax.crypto.SecretKey;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;

/**
 * Component responsible for JWT token validation and extraction of information
 * from tokens.
 * This class provides methods to validate JWT tokens and extract user email
 * from valid tokens.
 */
@Component
public class JwtTokenValidator {

    /**
     * The secret key used for JWT token validation.
     * Injected from application properties.
     */
    @Value("${jwt.secret}")
    private String jwtSecret;

    /**
     * Creates a signing key from the JWT secret.
     * 
     * @return SecretKey instance used for JWT token validation
     */
    private SecretKey getSigningKey() {
        return Keys.hmacShaKeyFor(jwtSecret.getBytes());
    }

    /**
     * Validates a JWT token.
     * 
     * @param token the JWT token to validate
     * @return true if the token is valid, false otherwise
     */
    public boolean validateToken(String token) {
        try {
            Jwts.parser()
                    .verifyWith(getSigningKey())
                    .build()
                    .parseSignedClaims(token);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            return false;
        }
    }

    /**
     * Extracts the email (subject) from a JWT token.
     * 
     * @param token the JWT token to extract information from
     * @return the email address stored in the token's subject claim
     */
    public String getEmailFromJWT(String token) {
        Claims claims = Jwts.parser()
                .verifyWith(getSigningKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();

        return claims.getSubject();
    }
}
