FROM openjdk:21-jdk-slim

WORKDIR /app

COPY target/notification-service-1.0.0.jar app.jar

EXPOSE 8084

CMD ["java", "-jar", "app.jar"]
