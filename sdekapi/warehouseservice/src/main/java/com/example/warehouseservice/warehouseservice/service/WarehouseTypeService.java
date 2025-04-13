package com.example.warehouseservice.warehouseservice.service;

import com.eventstore.dbclient.EventData;
import com.eventstore.dbclient.EventStoreDBClient;
import com.example.warehouseservice.warehouseservice.model.WarehouseType;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.SneakyThrows;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

@Service
public class WarehouseTypeService {
    private final EventStoreDBClient client;
    private final ObjectMapper objectMapper;

    public WarehouseTypeService(EventStoreDBClient client, ObjectMapper objectMapper) {
        this.client = client;
        this.objectMapper = objectMapper;
    }

    @SneakyThrows
    public WarehouseType addType(WarehouseType type) {
        final EventData data = EventData.builderAsBinary("warehouse_type_add", objectMapper.writeValueAsBytes(type)).build();
        client.appendToStream("warehouse_type", data).join();
        return type;
    }

    @SneakyThrows
    public WarehouseType updateType(WarehouseType type) {
        final EventData data = EventData.builderAsBinary("warehouse_type_update", objectMapper.writeValueAsBytes(type)).build();
        client.appendToStream("warehouse_type", data).join();
        return type;
    }

    @SneakyThrows
    public WarehouseType deleteType(WarehouseType type) {
        final EventData data = EventData.builderAsBinary("warehouse_type_delete", objectMapper.writeValueAsBytes(type)).build();
        client.appendToStream("warehouse_type", data).join();
        return type;
    }
}
