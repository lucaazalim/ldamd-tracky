# Tracky Backend - Quick Start Guide

This guide will help you get the Tracky microservices backend up and running with HashiCorp Consul for service discovery.

## Prerequisites

- Docker and Docker Compose installed
- Java 17+ (for local development)
- Maven 3.6+ (for local development)

## Architecture Overview

The Tracky backend consists of the following services:

- **Consul**: Service discovery and configuration management
- **API Gateway**: Entry point for all client requests (routes to `/api/*` endpoints)
- **User Service**: User management and authentication
- **Order Service**: Order processing and management
- **Tracking Service**: Package tracking functionality

## Quick Start (Docker)

### 1. Build All Services

```bash
# Make the build script executable
chmod +x build-all.sh

# Build all services
./build-all.sh
```

### 2. Start the Stack

```bash
# Start all services in detached mode
docker-compose up -d

# Check the status
docker-compose ps

# Follow logs
docker-compose logs -f
```

### 3. Verify Services

- **Consul UI**: <http://localhost:8500/ui>
- **API Gateway**: <http://localhost:8080>

## Service URLs

| Service          | Port | URL                                | Swagger UI                                    |
| ---------------- | ---- | ---------------------------------- | --------------------------------------------- |
| Consul           | 8500 | <http://localhost:8500>            | N/A                                           |
| API Gateway      | 8080 | <http://localhost:8080>            | <http://localhost:8080/swagger-ui/index.html> |
| User Service     | 8081 | <http://localhost:8081> (internal) | <http://localhost:8081/swagger-ui/index.html> |
| Order Service    | 8082 | <http://localhost:8082> (internal) | <http://localhost:8082/swagger-ui/index.html> |
| Tracking Service | 8083 | <http://localhost:8083> (internal) | <http://localhost:8083/swagger-ui/index.html> |

### API Gateway Routes

All external API requests should go through the API Gateway at `http://localhost:8080`:

- **User APIs**: `GET/POST/PUT/DELETE http://localhost:8080/api/users/**`
- **Order APIs**: `GET/POST/PUT/DELETE http://localhost:8080/api/orders/**`
- **Tracking APIs**: `GET/POST/PUT/DELETE http://localhost:8080/api/tracking/**`

The API Gateway automatically routes requests to the appropriate microservice based on the path prefix.

## Service Discovery with Consul

All microservices automatically register with Consul when they start up. The API Gateway uses Consul to discover and route requests to the appropriate services.

### Consul Features Used

- **Service Registration**: Services automatically register themselves
- **Health Checks**: Each service provides health endpoints
- **Load Balancing**: API Gateway uses `lb://service-name` for routing
- **Service Discovery**: Dynamic service resolution

## Development

### Running Services Locally

For local development, you can run services individually:

```bash
# Start Consul first
docker run -d --name consul -p 8500:8500 consul:1.15.2 agent -server -bootstrap -ui -client=0.0.0.0 -bind=0.0.0.0

# Run each service with local profile
cd user-service
mvn spring-boot:run -Dspring-boot.run.profiles=local
```

### Environment Variables

For Docker deployment, the following environment variables are used:

- `CONSUL_HOST`: Consul server hostname (default: consul)
- `CONSUL_PORT`: Consul server port (default: 8500)
- `DB_HOST`: Database hostname
- `DB_PORT`: Database port
- `DB_NAME`: Database name
- `DB_USERNAME`: Database username
- `DB_PASSWORD`: Database password
- `JWT_SECRET`: JWT signing secret

## Configuration

Each service manages its own configuration through `application.yml` files with support for different profiles (local, docker). This provides:

- **Self-contained services**: Each service is completely independent
- **Profile-based configuration**: Separate settings for local development and Docker deployment
- **Environment variable support**: Override configurations using Docker environment variables
- **No external dependencies**: Services don't depend on a central configuration server

## Architecture

This system uses a modern microservices architecture with:

- **HashiCorp Consul** for service discovery with:

  - Built-in health checking
  - Key-value configuration storage
  - Better Docker integration
  - Service mesh capabilities
  - Multi-datacenter support

- **Decentralized Configuration** providing:
  - Self-contained services
  - Faster startup times
  - No single point of failure
  - Simplified deployment
  - Independent service scaling

The architecture maintains API compatibility while providing excellent operational features and improved resilience.

## Resilience Patterns

The API Gateway implements modern resilience patterns using Resilience4j:

### Circuit Breaker

- **Purpose**: Prevents cascading failures by stopping calls to failing services
- **Configuration**: Per-service circuit breakers with configurable thresholds
- **States**: CLOSED (normal) → OPEN (failing) → HALF_OPEN (testing recovery)
- **Fallback**: Graceful degradation with meaningful error responses

### Retry Mechanism

- **Purpose**: Automatically retries failed requests with exponential backoff
- **Configuration**: 3 retry attempts with exponential backoff (50ms to 500ms)
- **Scope**: Applied to all service calls through the gateway

### Monitoring

- **Health Endpoints**: `/actuator/health`, `/actuator/circuitbreakers`, `/actuator/retries`
- **Custom Endpoints**: `/actuator/resilience/circuit-breakers`, `/actuator/resilience/retries`
- **Metrics**: Real-time circuit breaker state and retry statistics

## API Routes Summary

Below is a summarized list of all available routes for each microservice:

### User Service (`/api/users/*`)

| Method | Endpoint       | Description                             |
| ------ | -------------- | --------------------------------------- |
| POST   | `/users`       | Register a new customer or driver       |
| POST   | `/users/login` | Authenticate user and receive JWT token |

### Order Service (`/api/orders/*`)

| Method | Endpoint                  | Description                                     |
| ------ | ------------------------- | ----------------------------------------------- |
| GET    | `/orders/{id}`            | Get order details by ID                         |
| PUT    | `/orders/{id}`            | Update order details                            |
| DELETE | `/orders/{id}`            | Delete an order                                 |
| GET    | `/orders`                 | Get orders by customer ID, driver ID, or status |
| POST   | `/orders`                 | Create a new delivery order                     |
| GET    | `/orders/{orderId}/route` | Get the fastest route for an order              |

### Tracking Service (`/api/tracking/*`)

| Method | Endpoint                     | Description                               |
| ------ | ---------------------------- | ----------------------------------------- |
| POST   | `/tracking`                  | Add new tracking location for an order    |
| GET    | `/tracking/{orderId}/latest` | Get the latest tracking info for an order |

**Note**: All these endpoints should be accessed through the API Gateway at `http://localhost:8080/api/*`. The service-specific base URLs (e.g., `http://localhost:8081`) are for internal use only.

For detailed API documentation, refer to the Swagger UI for each service at the URLs listed in the [Service URLs](#service-urls) section.
