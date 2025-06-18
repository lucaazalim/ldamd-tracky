package com.tracky.orderservice.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.tracky.orderservice.model.Order;

/**
 * Repository interface for Order entities.
 * Provides methods to interact with the orders database table.
 */
@Repository
public interface OrderRepository extends JpaRepository<Order, UUID> {
    /**
     * Finds all orders belonging to a specific customer.
     *
     * @param customerId the ID of the customer
     * @return a list of orders associated with the customer
     */
    List<Order> findByCustomerId(UUID customerId);

    /**
     * Finds all orders with a specific status.
     *
     * @param status the order status to filter by
     * @return a list of orders with the specified status
     */
    List<Order> findByStatus(Order.OrderStatus status);

    /**
     * Finds all orders assigned to a specific driver.
     *
     * @param driverId the ID of the driver
     * @return a list of orders assigned to the driver
     */
    List<Order> findByDriverId(UUID driverId);
}
