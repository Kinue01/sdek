package com.example.servicesservice.service;

import com.eventstore.dbclient.EventData;
import com.eventstore.dbclient.EventStoreDBClient;
import com.example.servicesservice.model.DbService;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.SneakyThrows;
import org.springframework.stereotype.Service;

@Service
public class DbServiceService {
    private final EventStoreDBClient client;
    private final ObjectMapper objectMapper;

    public DbServiceService(EventStoreDBClient client, ObjectMapper objectMapper) {
        this.client = client;
        this.objectMapper = objectMapper;
    }

    @SneakyThrows
    public DbService addService(DbService service) {
        final EventData data = EventData.builderAsBinary("service_add", objectMapper.writeValueAsBytes(service)).build();
        client.appendToStream("service", data).join();
        return service;
    }

    @SneakyThrows
    public DbService updateService(DbService service) {
        final EventData data = EventData.builderAsBinary("service_update", objectMapper.writeValueAsBytes(service)).build();
        client.appendToStream("service", data).join();
        return service;
    }

    @SneakyThrows
    public DbService deleteService(DbService service) {
        final EventData data = EventData.builderAsBinary("service_delete", objectMapper.writeValueAsBytes(service)).build();
        client.appendToStream("service", data).join();
        return service;
    }
}
