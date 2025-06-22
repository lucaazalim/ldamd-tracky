package com.tracky.notificationservice.listener;

import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.tracky.notificationservice.dto.CampaignNotificationRequest;
import com.tracky.notificationservice.service.NotificationService;

import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class CampaignNotificationListener {

    @Autowired
    private NotificationService notificationService;

    @Autowired
    private ObjectMapper objectMapper;

    @RabbitListener(queues = "${app.rabbitmq.queue.campaign-notification}")
    public void handleCampaignNotification(String message) {
        try {
            log.info("Received campaign notification: {}", message);
            CampaignNotificationRequest request = objectMapper.readValue(message, CampaignNotificationRequest.class);
            notificationService.processCampaignNotification(request);
        } catch (Exception e) {
            log.error("Failed to process campaign notification: {}", message, e);
        }
    }
}
