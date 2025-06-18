package com.tracky.trackingservice.repository;

import com.tracky.trackingservice.model.Tracking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

/**
 * Repository for managing Tracking entity persistence.
 */
@Repository
public interface TrackingRepository extends JpaRepository<Tracking, UUID> {

    /**
     * Finds the most recent tracking record for a specific order.
     *
     * @param orderId The ID of the order to find tracking for
     * @return Optional containing the latest tracking record if found
     */
    @Query("SELECT t FROM Tracking t WHERE t.orderId = :orderId ORDER BY t.createdAt DESC LIMIT 1")
    Optional<Tracking> findLatestByOrderId(@Param("orderId") UUID orderId);
}
