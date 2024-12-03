package com.example.servicesservice;

import com.eventstore.dbclient.EventStoreDBClient;
import com.eventstore.dbclient.EventStoreDBClientSettings;
import com.eventstore.dbclient.EventStoreDBConnectionString;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;

@Configuration
@EnableAsync
public class AppConfig {
    @Bean
    public EventStoreDBClient eventStoreDBClient() {
        final EventStoreDBClientSettings settings = EventStoreDBConnectionString.parseOrThrow("esdb://admin:@eventstore:2113?tls=false");
        return EventStoreDBClient.create(settings);
    }
}