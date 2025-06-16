package com.tracky.orderservice.repository;

import com.tracky.orderservice.model.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface OrderRepository extends JpaRepository<Order, UUID> {
    List<Order> findByCustomerId(UUID customerId);

    List<Order> findByStatus(Order.OrderStatus status);

    List<Order> findByDriverId(UUID driverId);
}
