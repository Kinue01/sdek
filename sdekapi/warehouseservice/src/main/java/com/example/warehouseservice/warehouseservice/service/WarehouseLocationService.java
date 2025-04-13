package com.example.warehouseservice.warehouseservice.service;

import com.eventstore.dbclient.EventData;
import com.eventstore.dbclient.EventStoreDBClient;
import com.example.warehouseservice.warehouseservice.model.WarehouseLocation;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.SneakyThrows;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.concurrent.CompletableFuture;

@Service
public class WarehouseLocationService {
    private final EventStoreDBClient client;
    private final ObjectMapper objectMapper;

    public WarehouseLocationService(EventStoreDBClient client, ObjectMapper objectMapper) {
        this.client = client;
        this.objectMapper = objectMapper;
    }

    @SneakyThrows
    public WarehouseLocation addWarehouseLocation(WarehouseLocation warehouseLocation) {
        final EventData data = EventData.builderAsBinary("warehouseLocation_add", objectMapper.writeValueAsBytes(warehouseLocation)).build();
        client.appendToStream("warehouseLocation", data).join();
        return warehouseLocation;
    }

    @SneakyThrows
    public WarehouseLocation updateWarehouseLocation(WarehouseLocation warehouseLocation) {
        final EventData data = EventData.builderAsBinary("warehouseLocation_update", objectMapper.writeValueAsBytes(warehouseLocation)).build();
        client.appendToStream("warehouseLocation", data).join();
        return warehouseLocation;
    }

    @SneakyThrows
    public WarehouseLocation deleteWarehouseLocation(WarehouseLocation warehouseLocation) {
        final EventData data = EventData.builderAsBinary("warehouseLocation_delete", objectMapper.writeValueAsBytes(warehouseLocation)).build();
        client.appendToStream("warehouseLocation", data).join();
        return warehouseLocation;
    }
}
