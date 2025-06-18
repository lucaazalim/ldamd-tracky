package com.tracky.orderservice.service;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.tracky.orderservice.dto.RouteResponse;

/**
 * Service for interacting with the Google Maps API to get route information.
 * Provides functionality to get directions between two addresses.
 */
@Service
public class GoogleMapsService {

    /**
     * API key for authenticating with Google Maps API.
     * Loaded from application properties with a default value for testing.
     */
    @Value("${google.maps.api.key:AIzaSyDu9ndl3FCCcfY1j04gAEQLO--XxuUxRBA}")
    private String apiKey;

    /**
     * RestTemplate for making HTTP requests to the Google Maps API.
     */
    @Autowired
    private RestTemplate restTemplate;

    /**
     * Object mapper for parsing JSON responses from the API.
     */
    private final ObjectMapper objectMapper;

    /**
     * Constructs a new GoogleMapsService with a default ObjectMapper.
     */
    public GoogleMapsService() {
        this.objectMapper = new ObjectMapper();
    }

    /**
     * Gets directions between two addresses using the Google Maps Directions API.
     * 
     * @param origin      the starting address
     * @param destination the ending address
     * @return a RouteResponse object containing route information
     * @throws RuntimeException if there's an error fetching or parsing the
     *                          directions
     */
    public RouteResponse getDirections(String origin, String destination) {
        try {
            String encodedOrigin = URLEncoder.encode(origin, StandardCharsets.UTF_8);
            String encodedDestination = URLEncoder.encode(destination, StandardCharsets.UTF_8);

            String url = String.format(
                    "https://maps.googleapis.com/maps/api/directions/json?origin=%s&destination=%s&mode=driving&departure_time=now&key=%s",
                    encodedOrigin, encodedDestination, apiKey);

            String response = restTemplate.getForObject(url, String.class);

            if (response == null) {
                throw new RuntimeException("No response from Google Maps API");
            }

            return parseDirectionsResponse(response);

        } catch (Exception e) {
            throw new RuntimeException("Error fetching directions from Google Maps API: " + e.getMessage(), e);
        }
    }

    /**
     * Parses the JSON response from the Google Maps Directions API.
     * 
     * @param jsonResponse the JSON string response from the API
     * @return a RouteResponse object containing the parsed route information
     * @throws RuntimeException if there's an error parsing the response or if the
     *                          API returned an error
     */
    private RouteResponse parseDirectionsResponse(String jsonResponse) {
        try {
            JsonNode root = objectMapper.readTree(jsonResponse);

            // Check if the response is valid
            String status = root.path("status").asText();
            if (!"OK".equals(status)) {
                throw new RuntimeException("Google Maps API error: " + status);
            }

            JsonNode routes = root.path("routes");
            if (routes.isEmpty()) {
                throw new RuntimeException("No routes found");
            }

            JsonNode route = routes.get(0); // Get the first (fastest) route
            JsonNode leg = route.path("legs").get(0); // Get the first leg

            // Extract route information
            String distance = leg.path("distance").path("text").asText();
            String duration = leg.path("duration").path("text").asText();
            String startAddress = leg.path("start_address").asText();
            String endAddress = leg.path("end_address").asText();
            String polyline = route.path("overview_polyline").path("points").asText();

            // Extract steps
            List<RouteResponse.RouteStep> steps = new ArrayList<>();
            JsonNode stepsNode = leg.path("steps");
            for (JsonNode step : stepsNode) {
                String instruction = step.path("html_instructions").asText();
                String stepDistance = step.path("distance").path("text").asText();
                String stepDuration = step.path("duration").path("text").asText();

                // Clean HTML from instructions
                instruction = instruction.replaceAll("<[^>]*>", "");

                steps.add(new RouteResponse.RouteStep(instruction, stepDistance, stepDuration));
            }

            return new RouteResponse(distance, duration, startAddress, endAddress, polyline, steps);

        } catch (Exception e) {
            throw new RuntimeException("Error parsing Google Maps API response: " + e.getMessage(), e);
        }
    }
}
