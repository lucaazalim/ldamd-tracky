package com.tracky.campaignservice.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.tracky.campaignservice.dto.CampaignRequest;
import com.tracky.campaignservice.dto.CampaignResponse;
import com.tracky.campaignservice.dto.NotificationRequest;
import com.tracky.campaignservice.dto.UserDto;
import com.tracky.campaignservice.model.Campaign;
import lombok.extern.slf4j.Slf4j;
import software.amazon.awssdk.enhanced.dynamodb.DynamoDbEnhancedClient;
import software.amazon.awssdk.enhanced.dynamodb.DynamoDbTable;
import software.amazon.awssdk.enhanced.dynamodb.TableSchema;
import software.amazon.awssdk.services.sns.SnsClient;
import software.amazon.awssdk.services.sns.model.PublishRequest;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.StreamSupport;

@Slf4j
public class CampaignService {
    
    private final DynamoDbTable<Campaign> campaignTable;
    private final SnsClient snsClient;
    private final UserServiceClient userServiceClient;
    private final ObjectMapper objectMapper;
    private final String snsTopicArn;
    
    public CampaignService(DynamoDbEnhancedClient dynamoDbClient, 
                          SnsClient snsClient,
                          UserServiceClient userServiceClient,
                          String tableName,
                          String snsTopicArn) {
        this.campaignTable = dynamoDbClient.table(tableName, TableSchema.fromBean(Campaign.class));
        this.snsClient = snsClient;
        this.userServiceClient = userServiceClient;
        this.snsTopicArn = snsTopicArn;
        this.objectMapper = new ObjectMapper();
        this.objectMapper.registerModule(new JavaTimeModule());
    }
    
    public CampaignResponse createCampaign(CampaignRequest request) {
        log.info("Creating campaign for user type: {} with message: {}", request.getUserType(), request.getMessage());
        
        // Create and save campaign
        Campaign campaign = new Campaign(request.getMessage(), request.getUserType());
        campaign.setStatus(Campaign.CampaignStatus.PROCESSING);
        campaignTable.putItem(campaign);
        
        try {
            // Get users from user service
            List<UserDto> users = userServiceClient.getUsersByType(request.getUserType());
            
            if (users == null || users.isEmpty()) {
                log.warn("No users found for type: {}", request.getUserType());
                campaign.setStatus(Campaign.CampaignStatus.COMPLETED);
                campaign.setUsersReached(0);
                campaign.setUpdatedAt(LocalDateTime.now());
                campaignTable.putItem(campaign);
                return mapToResponse(campaign);
            }
            
            // Send notifications to SNS
            int usersReached = 0;
            for (UserDto user : users) {
                try {
                    NotificationRequest notificationRequest = new NotificationRequest(
                            user.getDeviceToken(),
                            user.getEmail(),
                            request.getMessage(),
                            user.getName()
                    );
                    
                    String message = objectMapper.writeValueAsString(notificationRequest);
                    
                    PublishRequest publishRequest = PublishRequest.builder()
                            .topicArn(snsTopicArn)
                            .message(message)
                            .subject("Campaign Notification")
                            .build();
                            
                    snsClient.publish(publishRequest);
                    usersReached++;
                    log.debug("Sent notification request for user: {}", user.getEmail());
                } catch (Exception e) {
                    log.error("Failed to send notification request for user: {}", user.getEmail(), e);
                }
            }
            
            // Update campaign with results
            campaign.setStatus(Campaign.CampaignStatus.COMPLETED);
            campaign.setUsersReached(usersReached);
            campaign.setUpdatedAt(LocalDateTime.now());
            campaignTable.putItem(campaign);
            
            log.info("Campaign completed. Reached {} users out of {} available users", usersReached, users.size());
            return mapToResponse(campaign);
            
        } catch (Exception e) {
            log.error("Failed to execute campaign", e);
            campaign.setStatus(Campaign.CampaignStatus.FAILED);
            campaign.setUpdatedAt(LocalDateTime.now());
            campaignTable.putItem(campaign);
            throw new RuntimeException("Failed to execute campaign", e);
        }
    }
    
    public List<CampaignResponse> getAllCampaigns() {
        return StreamSupport.stream(campaignTable.scan().items().spliterator(), false)
                .map(this::mapToResponse)
                .toList();
    }
    
    private CampaignResponse mapToResponse(Campaign campaign) {
        return new CampaignResponse(
                campaign.getId(),
                campaign.getMessage(),
                campaign.getUserType(),
                campaign.getUsersReached(),
                campaign.getStatus(),
                campaign.getCreatedAt(),
                campaign.getUpdatedAt()
        );
    }
}
