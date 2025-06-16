package com.tracky.userservice.dto;

import java.util.UUID;

import com.tracky.userservice.model.User;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserResponse {

    private UUID id;
    private String name;
    private String email;
    private User.UserType type;

    public static UserResponse fromUser(User user) {
        return new UserResponse(user.getId(), user.getName(), user.getEmail(), user.getType());
    }
}
