package com.tracky.userservice.service;

import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.tracky.userservice.dto.LoginRequest;
import com.tracky.userservice.dto.LoginResponse;
import com.tracky.userservice.dto.UserRegistrationRequest;
import com.tracky.userservice.dto.UserResponse;
import com.tracky.userservice.model.User;
import com.tracky.userservice.repository.UserRepository;
import com.tracky.userservice.security.JwtTokenProvider;

/**
 * Service for managing user-related operations including registration and
 * authentication.
 */
@Service
public class UserService {

    /**
     * Repository for user data access.
     */
    @Autowired
    private UserRepository userRepository;

    /**
     * Encoder for securely hashing user passwords.
     */
    @Autowired
    private PasswordEncoder passwordEncoder;

    /**
     * Provider for JWT token generation and validation.
     */
    @Autowired
    private JwtTokenProvider jwtTokenProvider;

    /**
     * Registers a new user in the system.
     * 
     * @param request The registration details
     * @return User information response
     * @throws RuntimeException If the email is already registered
     */
    public UserResponse registerUser(UserRegistrationRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("Email already exists");
        }

        User user = new User();
        user.setName(request.getName());
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setType(request.getType());
        user.setDeviceToken(request.getDeviceToken());

        User savedUser = userRepository.save(user);
        return UserResponse.fromUser(savedUser);
    }

    /**
     * Authenticates a user with email and password.
     * 
     * @param request The login credentials
     * @return Authentication response with JWT token and user information
     * @throws RuntimeException If credentials are invalid
     */
    public LoginResponse authenticateUser(LoginRequest request) {
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new RuntimeException("Invalid credentials"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new RuntimeException("Invalid credentials");
        }

        String token = jwtTokenProvider.generateToken(user.getEmail());
        UserResponse userResponse = UserResponse.fromUser(user);

        return new LoginResponse(token, userResponse);
    }

    /**
     * Retrieves user information by user ID.
     * 
     * @param userId The ID of the user to retrieve
     * @return User information response
     * @throws RuntimeException If the user is not found
     */
    public UserResponse getUserById(UUID userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return UserResponse.fromUser(user);
    }

    /**
     * Updates the device token for a user.
     * 
     * @param userId      The ID of the user to update
     * @param deviceToken The new device token
     * @return Updated user information response
     * @throws RuntimeException If the user is not found
     */
    public UserResponse updateDeviceToken(UUID userId, String deviceToken) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        user.setDeviceToken(deviceToken);
        User updatedUser = userRepository.save(user);
        return UserResponse.fromUser(updatedUser);
    }
}
