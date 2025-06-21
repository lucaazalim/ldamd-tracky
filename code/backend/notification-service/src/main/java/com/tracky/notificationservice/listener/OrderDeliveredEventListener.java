package com.tracky.notificationservice.listener;

import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.tracky.notificationservice.event.OrderDeliveredEvent;
import com.tracky.notificationservice.service.NotificationService;

import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class OrderDeliveredEventListener {

    @Autowired
    private NotificationService notificationService;

    @Autowired
    private ObjectMapper objectMapper;

    @RabbitListener(queues = "${app.rabbitmq.queue.order-delivered}")
    public void handleOrderDeliveredEvent(String message) {
        try {
            log.info("Received order delivered event: {}", message);
            OrderDeliveredEvent event = objectMapper.readValue(message, OrderDeliveredEvent.class);
            notificationService.processOrderDeliveredEvent(event);
        } catch (Exception e) {
            log.error("Failed to process order delivered event: {}", message, e);
        }
    }
}
