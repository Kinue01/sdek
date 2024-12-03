package com.example.warehouseservice.warehouseservice.service;

import com.eventstore.dbclient.EventData;
import com.eventstore.dbclient.EventStoreDBClient;
import com.example.warehouseservice.warehouseservice.model.Warehouse;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

@Service
public class WarehouseService {
    private final EventStoreDBClient client;

    public WarehouseService(EventStoreDBClient client) {
        this.client = client;
    }

    @Async
    public CompletableFuture<Warehouse> addWarehouse(Warehouse warehouse) {
        final EventData data = EventData.builderAsJson("warehouse_add", warehouse).build();
        client.appendToStream("warehouse", data).join();
        return CompletableFuture.completedFuture(warehouse);
    }

    @Async
    public CompletableFuture<Warehouse> updateWarehouse(Warehouse warehouse) {
        final EventData data = EventData.builderAsJson("warehouse_update", warehouse).build();
        client.appendToStream("warehouse", data).join();
        return CompletableFuture.completedFuture(warehouse);
    }

    @Async
    public CompletableFuture<Warehouse> deleteWarehouse(Warehouse warehouse) {
        final EventData data = EventData.builderAsJson("warehouse_delete", warehouse).build();
        client.appendToStream("warehouse", data).join();
        return CompletableFuture.completedFuture(warehouse);
    }
}
