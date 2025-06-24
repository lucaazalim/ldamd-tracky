package com.tracky.notificationservice.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import software.amazon.awssdk.enhanced.dynamodb.mapper.annotations.DynamoDbBean;
import software.amazon.awssdk.enhanced.dynamodb.mapper.annotations.DynamoDbPartitionKey;
import software.amazon.awssdk.enhanced.dynamodb.mapper.annotations.DynamoDbSecondaryPartitionKey;
import software.amazon.awssdk.enhanced.dynamodb.mapper.annotations.DynamoDbSecondarySortKey;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
@DynamoDbBean
public class Notification {

    private String id;
    private String orderId;
    private String userId;
    private NotificationType type;
    private NotificationChannel channel;
    private String message;
    private NotificationStatus status;
    private String errorMessage;
    private LocalDateTime createdAt;
    private LocalDateTime sentAt;

    public Notification(String orderId, String userId, NotificationType type, 
                       NotificationChannel channel, String message) {
        this.id = UUID.randomUUID().toString();
        this.orderId = orderId;
        this.userId = userId;
        this.type = type;
        this.channel = channel;
        this.message = message;
        this.status = NotificationStatus.PENDING;
        this.createdAt = LocalDateTime.now();
    }

    @DynamoDbPartitionKey
    public String getId() {
        return id;
    }

    @DynamoDbSecondaryPartitionKey(indexNames = "UserIndex")
    public String getUserId() {
        return userId;
    }

    @DynamoDbSecondarySortKey(indexNames = "UserIndex")
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public enum NotificationType {
        ORDER_DELIVERED, CAMPAIGN
    }

    public enum NotificationChannel {
        PUSH, EMAIL
    }

    public enum NotificationStatus {
        PENDING, SENT, FAILED
    }
}
