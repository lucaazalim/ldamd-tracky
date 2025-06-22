package com.tracky.campaignservice.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.tracky.campaignservice.dto.CampaignRequest;
import com.tracky.campaignservice.dto.CampaignResponse;
import com.tracky.campaignservice.service.CampaignService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

/**
 * REST controller for managing campaigns.
 */
@RestController
@RequestMapping("/campaigns")
@Tag(name = "Campaign Management", description = "APIs for managing campaigns")
@RequiredArgsConstructor
public class CampaignController {

    private final CampaignService campaignService;

    /**
     * Creates and executes a new campaign.
     * 
     * @param request Campaign creation request
     * @return Response with campaign execution details
     */
    @PostMapping
    @Operation(summary = "Create campaign", description = "Create and execute a new campaign")
    public ResponseEntity<CampaignResponse> createCampaign(@Valid @RequestBody CampaignRequest request) {
        try {
            CampaignResponse response = campaignService.createCampaign(request);
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Retrieves all campaigns.
     * 
     * @return List of all campaigns
     */
    @GetMapping
    @Operation(summary = "Get all campaigns", description = "Retrieve all campaigns")
    public ResponseEntity<List<CampaignResponse>> getAllCampaigns() {
        List<CampaignResponse> campaigns = campaignService.getAllCampaigns();
        return ResponseEntity.ok(campaigns);
    }
}
