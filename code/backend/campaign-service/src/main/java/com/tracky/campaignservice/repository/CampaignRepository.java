package com.tracky.campaignservice.repository;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.tracky.campaignservice.model.Campaign;

/**
 * Repository interface for Campaign entity operations.
 */
@Repository
public interface CampaignRepository extends JpaRepository<Campaign, UUID> {
}
