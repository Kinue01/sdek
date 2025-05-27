package com.example.warehouseservice.warehouseservice.service;

import com.example.warehouseservice.warehouseservice.model.WarehouseType;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.kurrent.dbclient.EventData;
import io.kurrent.dbclient.KurrentDBClient;
import lombok.SneakyThrows;
import org.springframework.stereotype.Service;

@Service
public class WarehouseTypeService {
    private final KurrentDBClient client;
    private final ObjectMapper objectMapper;

    public WarehouseTypeService(KurrentDBClient client, ObjectMapper objectMapper) {
        this.client = client;
        this.objectMapper = objectMapper;
    }

    @SneakyThrows
    public WarehouseType addType(WarehouseType type) {
        final EventData data = EventData.builderAsJson("warehouse_type_add", objectMapper.writeValueAsBytes(type)).build();
        client.appendToStream("warehouse_type", data).join();
        return type;
    }

    @SneakyThrows
    public WarehouseType updateType(WarehouseType type) {
        final EventData data = EventData.builderAsJson("warehouse_type_update", objectMapper.writeValueAsBytes(type)).build();
        client.appendToStream("warehouse_type", data).join();
        return type;
    }

    @SneakyThrows
    public WarehouseType deleteType(WarehouseType type) {
        final EventData data = EventData.builderAsJson("warehouse_type_delete", objectMapper.writeValueAsBytes(type)).build();
        client.appendToStream("warehouse_type", data).join();
        return type;
    }
}
