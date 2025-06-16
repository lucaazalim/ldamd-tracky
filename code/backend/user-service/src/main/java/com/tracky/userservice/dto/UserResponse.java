package com.tracky.userservice.dto;

import com.tracky.userservice.model.User;

import java.util.UUID;

public class UserResponse {

    private UUID id;
    private String name;
    private String email;
    private User.UserType type;

    // Constructors
    public UserResponse() {
    }

    public UserResponse(UUID id, String name, String email, User.UserType type) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.type = type;
    }

    public static UserResponse fromUser(User user) {
        return new UserResponse(user.getId(), user.getName(), user.getEmail(), user.getType());
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

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

    public User.UserType getType() {
        return type;
    }

    public void setType(User.UserType type) {
        this.type = type;
    }
}
