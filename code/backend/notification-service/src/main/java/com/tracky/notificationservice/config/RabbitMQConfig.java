package com.tracky.notificationservice.config;

import org.springframework.amqp.core.Binding;
import org.springframework.amqp.core.BindingBuilder;
import org.springframework.amqp.core.Queue;
import org.springframework.amqp.core.TopicExchange;
import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class RabbitMQConfig {

    @Value("${app.rabbitmq.exchange:tracky.exchange}")
    private String exchange;

    @Value("${app.rabbitmq.queue.order-delivered:order.delivered.queue}")
    private String orderDeliveredQueue;

    @Value("${app.rabbitmq.routing-key.order-delivered:order.delivered}")
    private String orderDeliveredRoutingKey;

    @Bean
    public TopicExchange trackyExchange() {
        return new TopicExchange(exchange, true, false);
    }

    @Bean
    public Queue orderDeliveredQueue() {
        return new Queue(orderDeliveredQueue, true);
    }

    @Bean
    public Binding orderDeliveredBinding() {
        return BindingBuilder
                .bind(orderDeliveredQueue())
                .to(trackyExchange())
                .with(orderDeliveredRoutingKey);
    }

    @Bean
    public Jackson2JsonMessageConverter messageConverter() {
        return new Jackson2JsonMessageConverter();
    }

    @Bean
    public RabbitTemplate rabbitTemplate(ConnectionFactory connectionFactory) {
        RabbitTemplate rabbitTemplate = new RabbitTemplate(connectionFactory);
        rabbitTemplate.setMessageConverter(messageConverter());
        return rabbitTemplate;
    }
}
