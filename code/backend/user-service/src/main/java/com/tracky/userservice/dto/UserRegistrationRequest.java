package com.tracky.userservice.dto;

import com.tracky.userservice.model.User;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Data Transfer Object for user registration requests.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserRegistrationRequest {

    /**
     * Full name of the user.
     */
    @NotBlank(message = "Name is required")
    private String name;

    /**
     * Email address of the user.
     */
    @Email(message = "Invalid email format")
    @NotBlank(message = "Email is required")
    private String email;

    /**
     * Password for the user account.
     */
    @NotBlank(message = "Password is required")
    private String password;

    /**
     * Type of the user (customer or driver).
     */
    @NotNull(message = "User type is required")
    private User.UserType type;
}
