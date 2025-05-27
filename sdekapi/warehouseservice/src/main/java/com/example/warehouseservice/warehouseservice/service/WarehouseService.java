package com.example.warehouseservice.warehouseservice.service;

import com.example.warehouseservice.warehouseservice.model.Warehouse;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.kurrent.dbclient.EventData;
import io.kurrent.dbclient.KurrentDBClient;
import lombok.SneakyThrows;
import org.springframework.stereotype.Service;

@Service
public class WarehouseService {
    private final KurrentDBClient client;
    private final ObjectMapper objectMapper;

    public WarehouseService(KurrentDBClient client, ObjectMapper objectMapper) {
        this.client = client;
        this.objectMapper = objectMapper;
    }

    @SneakyThrows
    public Warehouse addWarehouse(Warehouse warehouse) {
        final EventData data = EventData.builderAsJson("warehouse_add", objectMapper.writeValueAsBytes(warehouse)).build();
        client.appendToStream("warehouse", data).join();
        return warehouse;
    }

    @SneakyThrows
    public Warehouse updateWarehouse(Warehouse warehouse) {
        final EventData data = EventData.builderAsJson("warehouse_update", objectMapper.writeValueAsBytes(warehouse)).build();
        client.appendToStream("warehouse", data).join();
        return warehouse;
    }

    @SneakyThrows
    public Warehouse deleteWarehouse(Warehouse warehouse) {
        final EventData data = EventData.builderAsJson("warehouse_delete", objectMapper.writeValueAsBytes(warehouse)).build();
        client.appendToStream("warehouse", data).join();
        return warehouse;
    }
}
