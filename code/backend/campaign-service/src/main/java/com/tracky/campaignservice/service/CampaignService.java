package com.tracky.campaignservice.service;

import java.util.List;

import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.tracky.campaignservice.client.UserServiceClient;
import com.tracky.campaignservice.dto.CampaignRequest;
import com.tracky.campaignservice.dto.CampaignResponse;
import com.tracky.campaignservice.dto.NotificationRequest;
import com.tracky.campaignservice.dto.UserDto;
import com.tracky.campaignservice.model.Campaign;
import com.tracky.campaignservice.repository.CampaignRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

/**
 * Service for managing campaigns.
 */
@Service
@Slf4j
@RequiredArgsConstructor
public class CampaignService {

    private final CampaignRepository campaignRepository;
    private final UserServiceClient userServiceClient;
    private final RabbitTemplate rabbitTemplate;

    @Value("${app.rabbitmq.exchange:tracky.exchange}")
    private String exchange;

    @Value("${app.rabbitmq.routing-key.campaign-notification:campaign.notification}")
    private String campaignNotificationRoutingKey;

    /**
     * Creates and executes a new campaign.
     * 
     * @param request Campaign creation request
     * @return Campaign response with execution details
     */
    @Transactional
    public CampaignResponse createCampaign(CampaignRequest request) {
        log.info("Creating campaign for user type: {} with message: {}", request.getUserType(), request.getMessage());

        // Create and save campaign
        Campaign campaign = new Campaign(request.getMessage(), request.getUserType());
        campaign.setStatus(Campaign.CampaignStatus.PROCESSING);
        campaign = campaignRepository.save(campaign);

        try {
            // Get users from user service
            List<UserDto> users = userServiceClient.getUsersByType(request.getUserType());

            if (users == null || users.isEmpty()) {
                log.warn("No users found for type: {}", request.getUserType());
                campaign.setStatus(Campaign.CampaignStatus.COMPLETED);
                campaign.setUsersReached(0);
                campaign = campaignRepository.save(campaign);
                return mapToResponse(campaign);
            }

            // Send notifications to RabbitMQ
            int usersReached = 0;
            for (UserDto user : users) {
                try {
                    NotificationRequest notificationRequest = new NotificationRequest(
                            user.getDeviceToken(),
                            user.getEmail(),
                            request.getMessage(),
                            user.getName());

                    rabbitTemplate.convertAndSend(exchange, campaignNotificationRoutingKey, notificationRequest);
                    usersReached++;
                    log.debug("Sent notification request for user: {}", user.getEmail());
                } catch (Exception e) {
                    log.error("Failed to send notification request for user: {}", user.getEmail(), e);
                }
            }

            // Update campaign with results
            campaign.setStatus(Campaign.CampaignStatus.COMPLETED);
            campaign.setUsersReached(usersReached);
            campaign = campaignRepository.save(campaign);

            log.info("Campaign completed. Reached {} users out of {} available users", usersReached, users.size());
            return mapToResponse(campaign);

        } catch (Exception e) {
            log.error("Failed to execute campaign", e);
            campaign.setStatus(Campaign.CampaignStatus.FAILED);
            campaign = campaignRepository.save(campaign);
            throw new RuntimeException("Failed to execute campaign", e);
        }
    }

    /**
     * Retrieves all campaigns.
     * 
     * @return List of all campaigns
     */
    public List<CampaignResponse> getAllCampaigns() {
        return campaignRepository.findAll().stream()
                .map(this::mapToResponse)
                .toList();
    }

    /**
     * Maps Campaign entity to CampaignResponse DTO.
     * 
     * @param campaign Campaign entity
     * @return CampaignResponse DTO
     */
    private CampaignResponse mapToResponse(Campaign campaign) {
        return new CampaignResponse(
                campaign.getId(),
                campaign.getMessage(),
                campaign.getUserType(),
                campaign.getUsersReached(),
                campaign.getStatus(),
                campaign.getCreatedAt(),
                campaign.getUpdatedAt());
    }
}
