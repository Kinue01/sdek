package com.example.warehouseservice.warehouseservice.service;

import com.example.warehouseservice.warehouseservice.model.WarehouseLocation;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.kurrent.dbclient.EventData;
import io.kurrent.dbclient.KurrentDBClient;
import lombok.SneakyThrows;
import org.springframework.stereotype.Service;

@Service
public class WarehouseLocationService {
    private final KurrentDBClient client;
    private final ObjectMapper objectMapper;

    public WarehouseLocationService(KurrentDBClient client, ObjectMapper objectMapper) {
        this.client = client;
        this.objectMapper = objectMapper;
    }

    @SneakyThrows
    public WarehouseLocation addWarehouseLocation(WarehouseLocation warehouseLocation) {
        final EventData data = EventData.builderAsJson("warehouseLocation_add", objectMapper.writeValueAsBytes(warehouseLocation)).build();
        client.appendToStream("warehouseLocation", data).join();
        return warehouseLocation;
    }

    @SneakyThrows
    public WarehouseLocation updateWarehouseLocation(WarehouseLocation warehouseLocation) {
        final EventData data = EventData.builderAsJson("warehouseLocation_update", objectMapper.writeValueAsBytes(warehouseLocation)).build();
        client.appendToStream("warehouseLocation", data).join();
        return warehouseLocation;
    }

    @SneakyThrows
    public WarehouseLocation deleteWarehouseLocation(WarehouseLocation warehouseLocation) {
        final EventData data = EventData.builderAsJson("warehouseLocation_delete", objectMapper.writeValueAsBytes(warehouseLocation)).build();
        client.appendToStream("warehouseLocation", data).join();
        return warehouseLocation;
    }
}
