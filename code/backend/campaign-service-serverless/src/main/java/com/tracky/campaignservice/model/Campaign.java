package com.tracky.campaignservice.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import software.amazon.awssdk.enhanced.dynamodb.mapper.annotations.DynamoDbBean;
import software.amazon.awssdk.enhanced.dynamodb.mapper.annotations.DynamoDbPartitionKey;
import software.amazon.awssdk.enhanced.dynamodb.mapper.annotations.DynamoDbSecondaryPartitionKey;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
@DynamoDbBean
public class Campaign {

    private String id;
    private String message;
    private String userType;
    private Integer usersReached;
    private CampaignStatus status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Campaign(String message, String userType) {
        this.id = UUID.randomUUID().toString();
        this.message = message;
        this.userType = userType;
        this.usersReached = 0;
        this.status = CampaignStatus.CREATED;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    @DynamoDbPartitionKey
    public String getId() {
        return id;
    }

    @DynamoDbSecondaryPartitionKey(indexNames = "CreatedAtIndex")  
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public enum CampaignStatus {
        CREATED, PROCESSING, COMPLETED, FAILED
    }
}
