package com.tracky.orderservice.service;

import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.tracky.orderservice.event.OrderDeliveredEvent;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class OrderEventPublisher {

    private final RabbitTemplate rabbitTemplate;
    private final ObjectMapper objectMapper;

    @Value("${app.rabbitmq.exchange:tracky.exchange}")
    private String exchange;

    @Value("${app.rabbitmq.routing-key.order-delivered:order.delivered}")
    private String orderDeliveredRoutingKey;

    public OrderEventPublisher(RabbitTemplate rabbitTemplate, ObjectMapper objectMapper) {
        this.rabbitTemplate = rabbitTemplate;
        this.objectMapper = objectMapper;
    }

    public void publishOrderDeliveredEvent(OrderDeliveredEvent event) {
        try {
            String eventJson = objectMapper.writeValueAsString(event);
            rabbitTemplate.convertAndSend(exchange, orderDeliveredRoutingKey, eventJson);
            log.info("Published order delivered event for order ID: {}", event.getOrderId());
        } catch (JsonProcessingException e) {
            log.error("Failed to serialize order delivered event for order ID: {}", event.getOrderId(), e);
            throw new RuntimeException("Failed to publish order delivered event", e);
        }
    }
}
