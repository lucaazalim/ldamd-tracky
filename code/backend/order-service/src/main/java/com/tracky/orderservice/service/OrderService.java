package com.tracky.orderservice.service;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tracky.orderservice.dto.CreateOrderRequest;
import com.tracky.orderservice.dto.OrderResponse;
import com.tracky.orderservice.dto.UpdateOrderRequest;
import com.tracky.orderservice.model.Order;
import com.tracky.orderservice.repository.OrderRepository;

@Service
public class OrderService {

    @Autowired
    private OrderRepository orderRepository;

    public OrderResponse createOrder(CreateOrderRequest request) {
        Order order = new Order();
        order.setCustomerId(request.getCustomerId());
        order.setAddress(request.getAddress());
        order.setDescription(request.getDescription());
        order.setImageUrl(request.getImageUrl());

        Order savedOrder = orderRepository.save(order);
        return OrderResponse.fromOrder(savedOrder);
    }

    public OrderResponse getOrderById(UUID id) {
        Order order = orderRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Order not found"));
        return OrderResponse.fromOrder(order);
    }

    public List<OrderResponse> getOrdersByCustomer(UUID customerId) {
        List<Order> orders = orderRepository.findByCustomerId(customerId);
        return orders.stream()
                .map(OrderResponse::fromOrder)
                .collect(Collectors.toList());
    }

    public List<OrderResponse> getOrdersByStatus(Order.OrderStatus status) {
        List<Order> orders = orderRepository.findByStatus(status);
        return orders.stream()
                .map(OrderResponse::fromOrder)
                .collect(Collectors.toList());
    }

    public List<OrderResponse> getOrdersByDriver(UUID driverId) {
        List<Order> orders = orderRepository.findByDriverId(driverId);
        return orders.stream()
                .map(OrderResponse::fromOrder)
                .collect(Collectors.toList());
    }

    public OrderResponse updateOrder(UUID id, UpdateOrderRequest request) {
        Order order = orderRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Order not found"));

        if (request.getDriverId() != null) {
            order.setDriverId(request.getDriverId());
        }
        if (request.getStatus() != null) {
            order.setStatus(request.getStatus());
        }
        if (request.getAddress() != null) {
            order.setAddress(request.getAddress());
        }
        if (request.getDescription() != null) {
            order.setDescription(request.getDescription());
        }
        if (request.getImageUrl() != null) {
            order.setImageUrl(request.getImageUrl());
        }

        Order updatedOrder = orderRepository.save(order);
        return OrderResponse.fromOrder(updatedOrder);
    }

    public void deleteOrder(UUID id) {
        if (!orderRepository.existsById(id)) {
            throw new RuntimeException("Order not found");
        }
        orderRepository.deleteById(id);
    }
}
