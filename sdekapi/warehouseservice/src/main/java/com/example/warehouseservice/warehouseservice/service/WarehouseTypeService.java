package com.example.warehouseservice.warehouseservice.service;

import com.eventstore.dbclient.EventData;
import com.eventstore.dbclient.EventStoreDBClient;
import com.example.warehouseservice.warehouseservice.model.WarehouseType;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

@Service
public class WarehouseTypeService {
    private final EventStoreDBClient client;

    public WarehouseTypeService(EventStoreDBClient client) {
        this.client = client;
    }

    @Async
    public CompletableFuture<WarehouseType> addType(WarehouseType type) {
        final EventData data = EventData.builderAsJson("warehouse_type_add", type).build();
        client.appendToStream("warehouse_type", data).join();
        return CompletableFuture.completedFuture(type);
    }

    @Async
    public CompletableFuture<WarehouseType> updateType(WarehouseType type) {
        final EventData data = EventData.builderAsJson("warehouse_type_update", type).build();
        client.appendToStream("warehouse_type", data).join();
        return CompletableFuture.completedFuture(type);
    }

    @Async
    public CompletableFuture<WarehouseType> deleteType(WarehouseType type) {
        final EventData data = EventData.builderAsJson("warehouse_type_delete", type).build();
        client.appendToStream("warehouse_type", data).join();
        return CompletableFuture.completedFuture(type);
    }
}
