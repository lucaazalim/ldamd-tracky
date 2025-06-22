package com.tracky.notificationservice.config;

import java.io.FileInputStream;
import java.io.IOException;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;

import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;

@Configuration
@Slf4j
public class FirebaseConfig {

    @Value("${app.firebase.service-account-key-path:#{null}}")
    private String serviceAccountKeyPath;

    @PostConstruct
    public void initialize() {
        try {
            if (FirebaseApp.getApps().isEmpty()) {
                FirebaseOptions options;

                if (serviceAccountKeyPath != null && !serviceAccountKeyPath.trim().isEmpty()) {
                    // Use service account key file
                    FileInputStream serviceAccount = new FileInputStream(serviceAccountKeyPath);
                    options = FirebaseOptions.builder()
                            .setCredentials(GoogleCredentials.fromStream(serviceAccount))
                            .build();
                    log.info("Firebase Admin SDK initialized with service account key file");
                } else {
                    // Use default credentials (Google Application Default Credentials)
                    options = FirebaseOptions.builder()
                            .setCredentials(GoogleCredentials.getApplicationDefault())
                            .build();
                    log.info("Firebase Admin SDK initialized with default credentials");
                }

                FirebaseApp.initializeApp(options);
                log.info("Firebase Admin SDK initialized successfully");
            }
        } catch (IOException e) {
            log.error("Failed to initialize Firebase Admin SDK", e);
            throw new RuntimeException("Failed to initialize Firebase", e);
        }
    }
}
