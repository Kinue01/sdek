package com.example.warehouseservice.warehouseservice.service;

import com.eventstore.dbclient.EventData;
import com.eventstore.dbclient.EventStoreDBClient;
import com.example.warehouseservice.warehouseservice.model.Warehouse;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.SneakyThrows;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

@Service
public class WarehouseService {
    private final EventStoreDBClient client;
    private final ObjectMapper objectMapper;

    public WarehouseService(EventStoreDBClient client, ObjectMapper objectMapper) {
        this.client = client;
        this.objectMapper = objectMapper;
    }

    @SneakyThrows
    public Warehouse addWarehouse(Warehouse warehouse) {
        final EventData data = EventData.builderAsBinary("warehouse_add", objectMapper.writeValueAsBytes(warehouse)).build();
        client.appendToStream("warehouse", data).join();
        return warehouse;
    }

    @SneakyThrows
    public Warehouse updateWarehouse(Warehouse warehouse) {
        final EventData data = EventData.builderAsBinary("warehouse_update", objectMapper.writeValueAsBytes(warehouse)).build();
        client.appendToStream("warehouse", data).join();
        return warehouse;
    }

    @SneakyThrows
    public Warehouse deleteWarehouse(Warehouse warehouse) {
        final EventData data = EventData.builderAsBinary("warehouse_delete", objectMapper.writeValueAsBytes(warehouse)).build();
        client.appendToStream("warehouse", data).join();
        return warehouse;
    }
}
