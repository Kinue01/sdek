package com.example.warehousereadservice.warehousereadservice;

import io.kurrent.dbclient.KurrentDBClient;
import io.kurrent.dbclient.KurrentDBClientSettings;
import io.kurrent.dbclient.KurrentDBConnectionString;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AppConf {
    @Value("${app.eventstore.uri}")
    private String eventStoreUri;

    @Bean
    public KurrentDBClient eventStoreDBClient() {
        final KurrentDBClientSettings settings = KurrentDBConnectionString.parseOrThrow(eventStoreUri);
        return KurrentDBClient.create(settings);
    }
}
