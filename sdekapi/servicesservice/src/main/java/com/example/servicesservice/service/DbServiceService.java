package com.example.servicesservice.service;

import com.example.servicesservice.model.DbService;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.kurrent.dbclient.AppendToStreamOptions;
import io.kurrent.dbclient.EventData;
import io.kurrent.dbclient.KurrentDBClient;
import io.kurrent.dbclient.StreamState;
import lombok.SneakyThrows;
import org.springframework.stereotype.Service;

@Service
public class DbServiceService {
    private final KurrentDBClient client;
    private final ObjectMapper objectMapper;

    public DbServiceService(KurrentDBClient client, ObjectMapper objectMapper) {
        this.client = client;
        this.objectMapper = objectMapper;
    }

    @SneakyThrows
    public DbService addService(DbService service) {
        EventData data = EventData.builderAsJson("service_add", objectMapper.writeValueAsBytes(service)).build();
        client.appendToStream("service", data).join();
        return service;
    }

    @SneakyThrows
    public DbService updateService(DbService service) {
        EventData data = EventData.builderAsJson("service_update", objectMapper.writeValueAsBytes(service)).build();
        client.appendToStream("service", data).join();
        return service;
    }

    @SneakyThrows
    public DbService deleteService(DbService service) {
        EventData data = EventData.builderAsJson("service_delete", objectMapper.writeValueAsBytes(service)).build();
        client.appendToStream("service", data).join();
        return service;
    }
}
