package com.tracky.campaignservice.model;

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
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Entity representing a campaign in the Tracky system.
 */
@Entity
@Table(name = "campaigns")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Campaign {

    /**
     * Unique identifier for the campaign.
     */
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    /**
     * Message content of the campaign.
     */
    @NotBlank(message = "Message is required")
    @Column(nullable = false, columnDefinition = "TEXT")
    private String message;

    /**
     * Target user type for the campaign.
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "user_type", nullable = false)
    @NotNull(message = "User type is required")
    private UserType userType;

    /**
     * Number of users reached by this campaign.
     */
    @Column(name = "users_reached", nullable = false)
    private Integer usersReached = 0;

    /**
     * Status of the campaign.
     */
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private CampaignStatus status = CampaignStatus.PENDING;

    /**
     * Timestamp when the campaign was created.
     */
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    /**
     * Timestamp when the campaign was last updated.
     */
    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    /**
     * Defines the target user types for campaigns.
     */
    public enum UserType {
        CUSTOMER, DRIVER
    }

    /**
     * Defines the status of campaigns.
     */
    public enum CampaignStatus {
        PENDING, PROCESSING, COMPLETED, FAILED
    }

    /**
     * Creates a new campaign with message and user type.
     * 
     * @param message  The campaign message
     * @param userType The target user type
     */
    public Campaign(String message, UserType userType) {
        this.message = message;
        this.userType = userType;
    }
}
