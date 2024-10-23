package com.example.deliverypersonellreadservice.deliverypersonellreadservice;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;
import com.eventstore.dbclient.EventStoreDBClient;
import com.eventstore.dbclient.EventStoreDBClientSettings;
import com.eventstore.dbclient.EventStoreDBConnectionString;

@Configuration
@EnableAsync
public class AppConfig {
    @Bean
    public EventStoreDBClient eventStoreDBClient() {
        EventStoreDBClientSettings settings = EventStoreDBConnectionString.parseOrThrow("esdb://admin:@localhost:2113");
        return EventStoreDBClient.create(settings);
    }
}
