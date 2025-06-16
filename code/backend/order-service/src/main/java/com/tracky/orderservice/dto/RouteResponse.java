package com.tracky.orderservice.dto;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class RouteResponse {

    @JsonProperty("distance")
    private String distance;

    @JsonProperty("duration")
    private String duration;

    @JsonProperty("start_address")
    private String startAddress;

    @JsonProperty("end_address")
    private String endAddress;

    @JsonProperty("polyline")
    private String polyline;

    @JsonProperty("steps")
    private List<RouteStep> steps;

    // Inner class for route steps
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class RouteStep {
        @JsonProperty("instruction")
        private String instruction;

        @JsonProperty("distance")
        private String distance;

        @JsonProperty("duration")
        private String duration;
    }
}
