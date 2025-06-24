#!/bin/bash

echo "Building Notification Service Serverless..."

# Clean and build the project
mvn clean package -DskipTests

if [ $? -eq 0 ]; then
    echo "✅ Notification Service Serverless build completed successfully!"
    echo "JAR file created: target/notification-service-serverless.jar"
else
    echo "❌ Notification Service Serverless build failed!"
    exit 1
fi
