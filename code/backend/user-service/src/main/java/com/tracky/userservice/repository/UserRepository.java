package com.tracky.userservice.repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.tracky.userservice.model.User;

/**
 * Repository for managing User entity persistence.
 */
@Repository
public interface UserRepository extends JpaRepository<User, UUID> {

    /**
     * Finds a user by their email address.
     * 
     * @param email The email to search for
     * @return Optional containing the user if found
     */
    Optional<User> findByEmail(String email);

    /**
     * Checks if a user with the given email exists.
     * 
     * @param email The email to check
     * @return true if a user with the email exists, false otherwise
     */
    boolean existsByEmail(String email);

    /**
     * Finds users by their type.
     * 
     * @param type The user type to search for
     * @return List of users with the specified type
     */
    List<User> findByType(User.UserType type);
}
