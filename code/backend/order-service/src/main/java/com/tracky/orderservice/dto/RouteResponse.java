package com.tracky.orderservice.dto;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Data Transfer Object (DTO) for returning route information between two
 * addresses.
 * Contains details about a route including distance, duration, and turn-by-turn
 * directions.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class RouteResponse {

    /**
     * Total distance of the route (e.g., "5.2 km").
     */
    @JsonProperty("distance")
    private String distance;

    /**
     * Estimated travel time for the route (e.g., "15 mins").
     */
    @JsonProperty("duration")
    private String duration;

    /**
     * Formatted starting address of the route.
     */
    @JsonProperty("start_address")
    private String startAddress;

    /**
     * Formatted destination address of the route.
     */
    @JsonProperty("end_address")
    private String endAddress;

    /**
     * Encoded polyline string representing the route path.
     * Can be used for drawing the route on a map.
     */
    @JsonProperty("polyline")
    private String polyline;

    /**
     * List of turn-by-turn directions for navigating the route.
     */
    @JsonProperty("steps")
    private List<RouteStep> steps;

    /**
     * Inner class representing a single step in the route directions.
     * Each step contains an instruction and information about distance and
     * duration.
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class RouteStep {
        /**
         * Text instruction for this navigation step (e.g., "Turn right onto Main St").
         */
        @JsonProperty("instruction")
        private String instruction;

        /**
         * Distance for this step (e.g., "0.5 km").
         */
        @JsonProperty("distance")
        private String distance;

        /**
         * Estimated time to complete this step (e.g., "2 mins").
         */
        @JsonProperty("duration")
        private String duration;
    }
}
