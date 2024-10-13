package com.example.warehouseservice.warehouseservice;

import com.eventstore.dbclient.EventStoreDBClient;
import com.eventstore.dbclient.EventStoreDBClientSettings;
import com.eventstore.dbclient.EventStoreDBConnectionString;
import com.example.warehouseservice.warehouseservice.repository.WarehouseRepository;
import com.example.warehouseservice.warehouseservice.repository.WarehouseRepositoryImpl;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AppConfig {
    @Bean
    public WarehouseRepository warehouseRepository(EventStoreDBClient client) {
        return new WarehouseRepositoryImpl(client);
    }

    @Bean
    public EventStoreDBClient eventStoreDBClient() {
        EventStoreDBClientSettings settings = EventStoreDBConnectionString.parseOrThrow("esdb://admin:@localhost:2113");
        return EventStoreDBClient.create(settings);
    }
}
