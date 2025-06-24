#!/bin/bash

echo "Building Campaign Service Serverless..."

# Clean and build the project
mvn clean package -DskipTests

if [ $? -eq 0 ]; then
    echo "✅ Campaign Service Serverless build completed successfully!"
    echo "JAR file created: target/campaign-service-serverless.jar"
else
    echo "❌ Campaign Service Serverless build failed!"
    exit 1
fi
