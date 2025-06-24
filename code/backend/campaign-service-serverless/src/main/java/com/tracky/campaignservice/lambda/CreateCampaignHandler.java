package com.tracky.campaignservice.lambda;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import javax.naming.Context;
import javax.swing.plaf.synth.Region;
import javax.xml.validation.Validator;

import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyRequestEvent;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.tracky.campaignservice.service.UserServiceClient;

import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import lombok.extern.slf4j.Slf4j;
import main.java.com.tracky.campaignservice.dto.CampaignRequest;
import main.java.com.tracky.campaignservice.dto.CampaignResponse;
import main.java.com.tracky.campaignservice.service.CampaignService;
import software.amazon.awssdk.enhanced.dynamodb.DynamoDbEnhancedClient;
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;
import software.amazon.awssdk.services.sns.SnsClient;

@Slf4j
public class CreateCampaignHandler
        implements RequestHandler<APIGatewayProxyRequestEvent, APIGatewayProxyResponseEvent> {

    private final CampaignService campaignService;
    private final ObjectMapper objectMapper;
    private final Validator validator;

    public CreateCampaignHandler() {
        String region = System.getenv("REGION");
        String tableName = System.getenv("CAMPAIGN_TABLE");
        String userServiceUrl = System.getenv("USER_SERVICE_URL");
        String snsTopicArn = System.getenv("SNS_TOPIC_ARN");

        DynamoDbClient dynamoDbClient = DynamoDbClient.builder()
                .region(Region.of(region))
                .build();

        DynamoDbEnhancedClient enhancedClient = DynamoDbEnhancedClient.builder()
                .dynamoDbClient(dynamoDbClient)
                .build();

        SnsClient snsClient = SnsClient.builder()
                .region(Region.of(region))
                .build();

        UserServiceClient userServiceClient = new UserServiceClient(userServiceUrl);

        this.campaignService = new CampaignService(
                enhancedClient,
                snsClient,
                userServiceClient,
                tableName,
                snsTopicArn);

        this.objectMapper = new ObjectMapper();
        this.objectMapper.registerModule(new JavaTimeModule());

        this.validator = Validation.buildDefaultValidatorFactory().getValidator();
    }

    @Override
    public APIGatewayProxyResponseEvent handleRequest(APIGatewayProxyRequestEvent input, Context context) {
        log.info("Processing create campaign request");

        APIGatewayProxyResponseEvent response = new APIGatewayProxyResponseEvent();
        response.setHeaders(getCorsHeaders());

        try {
            String requestBody = input.getBody();
            if (requestBody == null || requestBody.trim().isEmpty()) {
                return createErrorResponse(400, "Request body is required");
            }

            CampaignRequest request = objectMapper.readValue(requestBody, CampaignRequest.class);

            // Validate request
            Set<ConstraintViolation<CampaignRequest>> violations = validator.validate(request);
            if (!violations.isEmpty()) {
                StringBuilder sb = new StringBuilder();
                for (ConstraintViolation<CampaignRequest> violation : violations) {
                    sb.append(violation.getMessage()).append("; ");
                }
                return createErrorResponse(400, "Validation errors: " + sb.toString());
            }

            CampaignResponse campaignResponse = campaignService.createCampaign(request);

            response.setStatusCode(201);
            response.setBody(objectMapper.writeValueAsString(campaignResponse));

            log.info("Campaign created successfully with ID: {}", campaignResponse.getId());

        } catch (Exception e) {
            log.error("Failed to create campaign", e);
            return createErrorResponse(500, "Internal server error: " + e.getMessage());
        }

        return response;
    }

    private APIGatewayProxyResponseEvent createErrorResponse(int statusCode, String message) {
        APIGatewayProxyResponseEvent response = new APIGatewayProxyResponseEvent();
        response.setStatusCode(statusCode);
        response.setHeaders(getCorsHeaders());

        Map<String, String> errorBody = new HashMap<>();
        errorBody.put("error", message);

        try {
            response.setBody(objectMapper.writeValueAsString(errorBody));
        } catch (Exception e) {
            response.setBody("{\"error\":\"" + message + "\"}");
        }

        return response;
    }

    private Map<String, String> getCorsHeaders() {
        Map<String, String> headers = new HashMap<>();
        headers.put("Content-Type", "application/json");
        headers.put("Access-Control-Allow-Origin", "*");
        headers.put("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
        headers.put("Access-Control-Allow-Headers", "Content-Type, Authorization");
        return headers;
    }
}
