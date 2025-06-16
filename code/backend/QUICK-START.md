# Tracky Backend - Quick Start Guide

This guide will help you get the Tracky microservices backend up and running with HashiCorp Consul for service discovery.

## Prerequisites

- Docker and Docker Compose installed
- Java 17+ (for local development)
- Maven 3.6+ (for local development)

## Architecture Overview

The Tracky backend consists of the following services:

- **Consul**: Service discovery and configuration management
- **Config Server**: Centralized configuration management
- **API Gateway**: Entry point for all client requests
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

- **Consul UI**: http://localhost:8500/ui
- **API Gateway**: http://localhost:8080
- **Config Server**: http://localhost:8888

## Service URLs

| Service          | Port | URL                              |
| ---------------- | ---- | -------------------------------- |
| Consul           | 8500 | http://localhost:8500            |
| API Gateway      | 8080 | http://localhost:8080            |
| Config Server    | 8888 | http://localhost:8888            |
| User Service     | 8081 | http://localhost:8081 (internal) |
| Order Service    | 8082 | http://localhost:8082 (internal) |
| Tracking Service | 8083 | http://localhost:8083 (internal) |

## Service Discovery with Consul

All microservices automatically register with Consul when they start up. The API Gateway uses Consul to discover and route requests to the appropriate services.

### Consul Features Used:

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

## Troubleshooting

### Common Issues

1. **Services not registering with Consul**

   - Check Consul is running and accessible
   - Verify CONSUL_HOST and CONSUL_PORT environment variables
   - Check service logs for connection errors

2. **API Gateway can't find services**

   - Ensure services are registered in Consul UI
   - Check load balancer configuration in gateway routes
   - Verify service names match in Consul and gateway routes

3. **Database connection issues**
   - Ensure PostgreSQL containers are running
   - Check database environment variables
   - Verify network connectivity

### Useful Commands

```bash
# View service logs
docker-compose logs -f <service-name>

# Restart a specific service
docker-compose restart <service-name>

# Check Consul members
docker exec consul consul members

# View Consul services
curl http://localhost:8500/v1/agent/services | jq

# Stop all services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

## Configuration

Services use Spring Cloud Config for centralized configuration management. Configuration files are located in the config server's resources.

## Migration from Eureka

This system has been migrated from Netflix Eureka to HashiCorp Consul for improved:

- Built-in health checking
- Key-value configuration storage
- Better Docker integration
- More robust service mesh capabilities
- Multi-datacenter support

The migration maintains API compatibility while providing better operational features.
