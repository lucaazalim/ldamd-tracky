package com.tracky.userservice.dto;

import com.tracky.userservice.model.User;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public class UserRegistrationRequest {

    @NotBlank(message = "Name is required")
    private String name;

    @Email(message = "Invalid email format")
    @NotBlank(message = "Email is required")
    private String email;

    @NotBlank(message = "Password is required")
    private String password;

    @NotNull(message = "User type is required")
    private User.UserType type;

    // Constructors
    public UserRegistrationRequest() {
    }

    public UserRegistrationRequest(String name, String email, String password, User.UserType type) {
        this.name = name;
        this.email = email;
        this.password = password;
        this.type = type;
    }

    // Getters and Setters
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public User.UserType getType() {
        return type;
    }

    public void setType(User.UserType type) {
        this.type = type;
    }
}
