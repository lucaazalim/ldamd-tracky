FROM eclipse-temurin:24-jre-alpine

WORKDIR /app

COPY target/api-gateway-1.0.0.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
