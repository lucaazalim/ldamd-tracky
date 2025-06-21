package com.tracky.orderservice.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.tracky.orderservice.dto.CreateOrderRequest;
import com.tracky.orderservice.dto.OrderResponse;
import com.tracky.orderservice.dto.RouteResponse;
import com.tracky.orderservice.dto.UpdateOrderRequest;
import com.tracky.orderservice.event.OrderDeliveredEvent;
import com.tracky.orderservice.model.Order;
import com.tracky.orderservice.repository.OrderRepository;

/**
 * Service class that provides business logic for managing orders.
 * Handles CRUD operations for orders and acts as an intermediary between
 * controllers and repositories.
 */
@Service
public class OrderService {

    /**
     * Repository for data access operations related to orders.
     */
    @Autowired
    private OrderRepository orderRepository;

    /**
     * Service for interacting with Google Maps API to get route information.
     */
    @Autowired
    private GoogleMapsService googleMapsService;

    @Autowired
    private OrderEventPublisher orderEventPublisher;

    /**
     * Creates a new order in the system.
     * 
     * @param request DTO containing information for the new order
     * @return DTO with details of the created order
     */
    public OrderResponse createOrder(CreateOrderRequest request) {
        Order order = new Order();
        order.setCustomerId(request.getCustomerId());
        order.setOriginAddress(request.getOriginAddress());
        order.setDestinationAddress(request.getDestinationAddress());
        order.setDescription(request.getDescription());
        order.setImageUrl(request.getImageUrl());

        Order savedOrder = orderRepository.save(order);
        return OrderResponse.fromOrder(savedOrder);
    }

    /**
     * Retrieves an order by its unique identifier.
     * 
     * @param id the ID of the order to retrieve
     * @return DTO with details of the requested order
     * @throws RuntimeException if the order is not found
     */
    public OrderResponse getOrderById(UUID id) {
        Order order = orderRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Order not found"));
        return OrderResponse.fromOrder(order);
    }

    /**
     * Retrieves all orders associated with a specific customer.
     * 
     * @param customerId the ID of the customer
     * @return list of DTOs with details of the customer's orders
     */
    public List<OrderResponse> getOrdersByCustomer(UUID customerId) {
        List<Order> orders = orderRepository.findByCustomerId(customerId);
        return orders.stream()
                .map(OrderResponse::fromOrder)
                .collect(Collectors.toList());
    }

    /**
     * Retrieves all orders with a specific status.
     * 
     * @param status the order status to filter by
     * @return list of DTOs with details of orders with the requested status
     */
    public List<OrderResponse> getOrdersByStatus(Order.OrderStatus status) {
        List<Order> orders = orderRepository.findByStatus(status);
        return orders.stream()
                .map(OrderResponse::fromOrder)
                .collect(Collectors.toList());
    }

    /**
     * Retrieves all orders assigned to a specific driver.
     * 
     * @param driverId the ID of the driver
     * @return list of DTOs with details of the driver's assigned orders
     */
    public List<OrderResponse> getOrdersByDriver(UUID driverId) {
        List<Order> orders = orderRepository.findByDriverId(driverId);
        return orders.stream()
                .map(OrderResponse::fromOrder)
                .collect(Collectors.toList());
    }

    /**
     * Updates an existing order with new information.
     * Only provided fields in the request will be updated.
     * 
     * @param id      the ID of the order to update
     * @param request DTO containing fields to update
     * @return DTO with details of the updated order
     * @throws RuntimeException if the order is not found
     */
    public OrderResponse updateOrder(UUID id, UpdateOrderRequest request) {
        Order order = orderRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Order not found"));

        Order.OrderStatus previousStatus = order.getStatus();

        if (request.getDriverId() != null) {
            order.setDriverId(request.getDriverId());
        }
        if (request.getStatus() != null) {
            order.setStatus(request.getStatus());
        }
        if (request.getOriginAddress() != null) {
            order.setOriginAddress(request.getOriginAddress());
        }
        if (request.getDestinationAddress() != null) {
            order.setDestinationAddress(request.getDestinationAddress());
        }
        if (request.getDescription() != null) {
            order.setDescription(request.getDescription());
        }
        if (request.getImageUrl() != null) {
            order.setImageUrl(request.getImageUrl());
        }

        Order updatedOrder = orderRepository.save(order);

        // Publish event if order status was updated to DELIVERED
        if (request.getStatus() != null &&
                request.getStatus() == Order.OrderStatus.DELIVERED &&
                previousStatus != Order.OrderStatus.DELIVERED) {

            OrderDeliveredEvent event = new OrderDeliveredEvent(
                    updatedOrder.getId(),
                    updatedOrder.getCustomerId(),
                    updatedOrder.getDriverId(),
                    updatedOrder.getOriginAddress(),
                    updatedOrder.getDestinationAddress(),
                    updatedOrder.getDescription(),
                    LocalDateTime.now());

            orderEventPublisher.publishOrderDeliveredEvent(event);
        }

        return OrderResponse.fromOrder(updatedOrder);
    }

    /**
     * Deletes an order from the system.
     * 
     * @param id the ID of the order to delete
     * @throws RuntimeException if the order is not found
     */
    public void deleteOrder(UUID id) {
        if (!orderRepository.existsById(id)) {
            throw new RuntimeException("Order not found");
        }
        orderRepository.deleteById(id);
    }

    /**
     * Gets route information between the origin and destination addresses of an
     * order.
     * 
     * @param orderId the ID of the order
     * @return DTO with route details including distance, duration, and turn-by-turn
     *         directions
     * @throws RuntimeException if the order is not found or if there's an issue
     *                          getting directions
     */
    public RouteResponse getOrderRoute(UUID orderId) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new RuntimeException("Order not found"));

        return googleMapsService.getDirections(order.getOriginAddress(), order.getDestinationAddress());
    }
}
