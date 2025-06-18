package com.tracky.orderservice.controller;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.tracky.orderservice.dto.CreateOrderRequest;
import com.tracky.orderservice.dto.OrderResponse;
import com.tracky.orderservice.dto.RouteResponse;
import com.tracky.orderservice.dto.UpdateOrderRequest;
import com.tracky.orderservice.model.Order;
import com.tracky.orderservice.service.OrderService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;

/**
 * REST controller for managing orders.
 * Provides endpoints for creating, retrieving, updating, and deleting orders,
 * as well as getting route information for deliveries.
 */
@RestController
@RequestMapping("/orders")
@Tag(name = "Order Management", description = "APIs for order management")
public class OrderController {

    /**
     * Service for handling order business logic.
     */
    @Autowired
    private OrderService orderService;

    /**
     * Creates a new order.
     * 
     * @param request DTO containing information for the new order
     * @return ResponseEntity with the created order details and HTTP 201 status
     */
    @PostMapping
    @Operation(summary = "Create new order", description = "Create a new delivery order")
    public ResponseEntity<OrderResponse> createOrder(@Valid @RequestBody CreateOrderRequest request) {
        try {
            OrderResponse response = orderService.createOrder(request);
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    /**
     * Retrieves an order by its ID.
     * 
     * @param id the ID of the order to retrieve
     * @return ResponseEntity with the order details or HTTP 404 if not found
     */
    @GetMapping("/{id}")
    @Operation(summary = "Get order by ID", description = "Retrieve order details by ID")
    public ResponseEntity<OrderResponse> getOrderById(@PathVariable UUID id) {
        try {
            OrderResponse response = orderService.getOrderById(id);
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    /**
     * Retrieves orders filtered by customer, driver, or status.
     * Exactly one filter parameter must be provided.
     * 
     * @param customer optional customer ID to filter by
     * @param driver   optional driver ID to filter by
     * @param status   optional order status to filter by
     * @return ResponseEntity with filtered orders or HTTP 400 if invalid request
     */
    @GetMapping
    @Operation(summary = "Get orders", description = "Get orders by customer ID, driver ID, or status")
    public ResponseEntity<List<OrderResponse>> getOrders(
            @RequestParam(required = false) UUID customer,
            @RequestParam(required = false) UUID driver,
            @RequestParam(required = false) Order.OrderStatus status) {

        try {
            List<OrderResponse> response;
            if (customer != null) {
                response = orderService.getOrdersByCustomer(customer);
            } else if (driver != null) {
                response = orderService.getOrdersByDriver(driver);
            } else if (status != null) {
                response = orderService.getOrdersByStatus(status);
            } else {
                return ResponseEntity.badRequest().build();
            }
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    /**
     * Updates an existing order.
     * 
     * @param id      the ID of the order to update
     * @param request DTO containing fields to update
     * @return ResponseEntity with updated order details or HTTP 404 if not found
     */
    @PutMapping("/{id}")
    @Operation(summary = "Update order", description = "Update order details")
    public ResponseEntity<OrderResponse> updateOrder(@PathVariable UUID id,
            @Valid @RequestBody UpdateOrderRequest request) {
        try {
            OrderResponse response = orderService.updateOrder(id, request);
            return ResponseEntity.ok(response);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    /**
     * Deletes an order.
     * 
     * @param id the ID of the order to delete
     * @return ResponseEntity with HTTP 204 status or HTTP 404 if not found
     */
    @DeleteMapping("/{id}")
    @Operation(summary = "Delete order", description = "Delete an order")
    public ResponseEntity<Void> deleteOrder(@PathVariable UUID id) {
        try {
            orderService.deleteOrder(id);
            return ResponseEntity.noContent().build();
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    /**
     * Gets route information for an order.
     * 
     * @param orderId the ID of the order
     * @return ResponseEntity with route details or appropriate error status
     */
    @GetMapping("/{orderId}/route")
    @Operation(summary = "Get route for order", description = "Get the fastest route between origin and destination addresses using Google Maps")
    public ResponseEntity<RouteResponse> getOrderRoute(@PathVariable UUID orderId) {
        try {
            RouteResponse route = orderService.getOrderRoute(orderId);
            return ResponseEntity.ok(route);
        } catch (RuntimeException e) {
            if (e.getMessage().contains("Order not found")) {
                return ResponseEntity.notFound().build();
            }
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
