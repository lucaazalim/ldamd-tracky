package com.tracky.campaignservice.lambda;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.swing.plaf.synth.Region;

import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyRequestEvent;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import com.tracky.campaignservice.service.UserServiceClient;

import lombok.extern.slf4j.Slf4j;
import main.java.com.tracky.campaignservice.dto.CampaignResponse;
import main.java.com.tracky.campaignservice.service.CampaignService;
import software.amazon.awssdk.enhanced.dynamodb.DynamoDbEnhancedClient;
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;
import software.amazon.awssdk.services.sns.SnsClient;

@Slf4j
public class GetAllCampaignsHandler
        implements RequestHandler<APIGatewayProxyRequestEvent, APIGatewayProxyResponseEvent> {

    private final CampaignService campaignService;
    private final ObjectMapper objectMapper;

    public GetAllCampaignsHandler() {
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
    }

    @Override
    public APIGatewayProxyResponseEvent handleRequest(APIGatewayProxyRequestEvent input, Context context) {
        log.info("Processing get all campaigns request");

        APIGatewayProxyResponseEvent response = new APIGatewayProxyResponseEvent();
        response.setHeaders(getCorsHeaders());

        try {
            List<CampaignResponse> campaigns = campaignService.getAllCampaigns();

            response.setStatusCode(200);
            response.setBody(objectMapper.writeValueAsString(campaigns));

            log.info("Retrieved {} campaigns", campaigns.size());

        } catch (Exception e) {
            log.error("Failed to get all campaigns", e);
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
