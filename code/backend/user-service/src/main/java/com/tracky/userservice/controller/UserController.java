package com.tracky.userservice.controller;

import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.tracky.userservice.dto.LoginRequest;
import com.tracky.userservice.dto.LoginResponse;
import com.tracky.userservice.dto.UserRegistrationRequest;
import com.tracky.userservice.dto.UserResponse;
import com.tracky.userservice.dto.UserUpdateRequest;
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

    /**
     * Retrieves user information by user ID.
     * 
     * @param userId The ID of the user to retrieve
     * @return Response with user information
     */
    @GetMapping("/{userId}")
    @Operation(summary = "Get user by ID", description = "Retrieve user information by user ID")
    public ResponseEntity<UserResponse> getUserById(@PathVariable UUID userId) {
        try {
            UserResponse response = userService.getUserById(userId);
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    /**
     * Updates user information.
     * 
     * @param userId  The ID of the user to update
     * @param request The user update request
     * @return Response with updated user information
     */
    @PutMapping("/{userId}")
    @Operation(summary = "Update user", description = "Update user information (currently supports device token)")
    public ResponseEntity<UserResponse> updateUser(
            @PathVariable UUID userId,
            @Valid @RequestBody UserUpdateRequest request) {
        try {
            UserResponse response = userService.updateUser(userId, request);
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }
}
