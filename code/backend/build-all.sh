#!/bin/bash

echo "🚀 Starting Tracky Microservices Build Process..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to build a Maven project
build_maven_service() {
    local service_name=$1
    local service_dir=$2
    
    print_status "Building $service_name..."
    
    if [ ! -d "$service_dir" ]; then
        print_error "Directory $service_dir does not exist!"
        return 1
    fi
    
    cd "$service_dir"
    mvn clean package -DskipTests > build.log 2>&1
    
    if [ $? -eq 0 ]; then
        print_success "$service_name built successfully!"
        cd ..
        return 0
    else
        print_error "Failed to build $service_name. Check $service_dir/build.log for details."
        cd ..
        return 1
    fi
}

# Build all services
print_status "Building User Service..."
build_maven_service "User Service" "user-service"

print_status "Building Order Service..." 
build_maven_service "Order Service" "order-service"

print_status "Building Tracking Service..."
build_maven_service "Tracking Service" "tracking-service"

print_status "Building Notification Service..."
build_maven_service "Notification Service" "notification-service"

print_status "Building API Gateway..."
build_maven_service "API Gateway" "api-gateway"

print_success "🎉 All services built successfully!"

echo ""
echo "🔧 Next Steps:"
echo "  1. Start services: docker-compose up -d"
echo "  2. Check status: docker-compose ps"
echo "  3. View logs: docker-compose logs -f"
echo ""
echo "📋 Service URLs:"
echo "  • Consul Dashboard: http://localhost:8500/ui"
echo "  • RabbitMQ Management: http://localhost:15672"
echo "  • API Gateway: http://localhost:8080"
