package com.tracky.userservice.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.tracky.userservice.dto.LoginRequest;
import com.tracky.userservice.dto.LoginResponse;
import com.tracky.userservice.dto.UserRegistrationRequest;
import com.tracky.userservice.dto.UserResponse;
import com.tracky.userservice.service.UserService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;

/**
 * REST controller for handling user registration and authentication.
 */
@RestController
@RequestMapping("/users")
@Tag(name = "User Management", description = "APIs for user registration and authentication")
public class UserController {

    /**
     * Service for user management operations.
     */
    @Autowired
    private UserService userService;

    /**
     * Registers a new user in the system.
     * 
     * @param request User registration data
     * @return Response with created user information
     */
    @PostMapping
    @Operation(summary = "Register new user", description = "Register a new customer or driver")
    public ResponseEntity<UserResponse> registerUser(@Valid @RequestBody UserRegistrationRequest request) {
        try {
            UserResponse response = userService.registerUser(request);
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    /**
     * Authenticates a user and provides a JWT token.
     * 
     * @param request Login credentials
     * @return Response with authentication token and user information
     */
    @PostMapping("/login")
    @Operation(summary = "Authenticate user", description = "Authenticate user and return JWT token")
    public ResponseEntity<LoginResponse> loginUser(@Valid @RequestBody LoginRequest request) {
        try {
            LoginResponse response = userService.authenticateUser(request);
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
    }
}
