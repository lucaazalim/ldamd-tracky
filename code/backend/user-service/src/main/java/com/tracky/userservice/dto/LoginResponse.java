package com.tracky.userservice.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Data Transfer Object for user login responses.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LoginResponse {

    /**
     * JWT authentication token.
     */
    private String token;
    
    /**
     * User information.
     */
    private UserResponse user;
}
