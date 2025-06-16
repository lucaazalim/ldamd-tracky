package com.tracky.orderservice.dto;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

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

    // Constructors
    public RouteResponse() {
    }

    public RouteResponse(String distance, String duration, String startAddress,
            String endAddress, String polyline, List<RouteStep> steps) {
        this.distance = distance;
        this.duration = duration;
        this.startAddress = startAddress;
        this.endAddress = endAddress;
        this.polyline = polyline;
        this.steps = steps;
    }

    // Getters and Setters
    public String getDistance() {
        return distance;
    }

    public void setDistance(String distance) {
        this.distance = distance;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public String getStartAddress() {
        return startAddress;
    }

    public void setStartAddress(String startAddress) {
        this.startAddress = startAddress;
    }

    public String getEndAddress() {
        return endAddress;
    }

    public void setEndAddress(String endAddress) {
        this.endAddress = endAddress;
    }

    public String getPolyline() {
        return polyline;
    }

    public void setPolyline(String polyline) {
        this.polyline = polyline;
    }

    public List<RouteStep> getSteps() {
        return steps;
    }

    public void setSteps(List<RouteStep> steps) {
        this.steps = steps;
    }

    // Inner class for route steps
    public static class RouteStep {
        @JsonProperty("instruction")
        private String instruction;

        @JsonProperty("distance")
        private String distance;

        @JsonProperty("duration")
        private String duration;

        public RouteStep() {
        }

        public RouteStep(String instruction, String distance, String duration) {
            this.instruction = instruction;
            this.distance = distance;
            this.duration = duration;
        }

        public String getInstruction() {
            return instruction;
        }

        public void setInstruction(String instruction) {
            this.instruction = instruction;
        }

        public String getDistance() {
            return distance;
        }

        public void setDistance(String distance) {
            this.distance = distance;
        }

        public String getDuration() {
            return duration;
        }

        public void setDuration(String duration) {
            this.duration = duration;
        }
    }
}
