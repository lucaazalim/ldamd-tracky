package com.tracky.userservice.model;

import java.time.LocalDateTime;
import java.util.UUID;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Entity representing a user in the Tracky system.
 */
@Entity
@Table(name = "users")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User {

    /**
     * Unique identifier for the user.
     */
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    /**
     * Full name of the user.
     */
    @NotBlank(message = "Name is required")
    @Column(nullable = false)
    private String name;

    /**
     * Email address of the user, serves as username for authentication.
     */
    @Email(message = "Invalid email format")
    @NotBlank(message = "Email is required")
    @Column(unique = true, nullable = false)
    private String email;

    /**
     * Encrypted password for user authentication.
     */
    @NotBlank(message = "Password is required")
    @Column(nullable = false)
    private String password;

    /**
     * Type of user (customer or driver).
     */
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private UserType type;

    /**
     * Device token for push notifications (FCM token).
     */
    @Column(name = "device_token")
    private String deviceToken;

    /**
     * Timestamp when the user record was created.
     */
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    /**
     * Timestamp when the user record was last updated.
     */
    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    /**
     * Defines the roles of users in the system.
     */
    public enum UserType {
        CUSTOMER, DRIVER
    }

    /**
     * Creates a new user with basic information.
     * 
     * @param name     The user's full name
     * @param email    The user's email address
     * @param password The user's password (will be encrypted)
     * @param type     The user's role type
     */
    public User(String name, String email, String password, UserType type) {
        this.name = name;
        this.email = email;
        this.password = password;
        this.type = type;
    }
}
