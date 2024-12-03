package com.example.warehouseservice.warehouseservice.service;

import com.eventstore.dbclient.EventData;
import com.eventstore.dbclient.EventStoreDBClient;
import com.example.warehouseservice.warehouseservice.model.WarehouseLocation;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.concurrent.CompletableFuture;

@Service
public class WarehouseLocationService {
    private final EventStoreDBClient client;

    public WarehouseLocationService(EventStoreDBClient client) {
        this.client = client;
    }

    @Async
    public CompletableFuture<WarehouseLocation> addWarehouseLocation(WarehouseLocation warehouseLocation) {
        final EventData data = EventData.builderAsJson("warehouseLocation_add", warehouseLocation).build();
        client.appendToStream("warehouseLocation", data).join();
        return CompletableFuture.completedFuture(warehouseLocation);
    }

    @Async
    public CompletableFuture<WarehouseLocation> updateWarehouseLocation(WarehouseLocation warehouseLocation) {
        final EventData data = EventData.builderAsJson("warehouseLocation_update", warehouseLocation).build();
        client.appendToStream("warehouseLocation", data).join();
        return CompletableFuture.completedFuture(warehouseLocation);
    }

    @Async
    public CompletableFuture<WarehouseLocation> deleteWarehouseLocation(WarehouseLocation warehouseLocation) {
        final EventData data = EventData.builderAsJson("warehouseLocation_delete", warehouseLocation).build();
        client.appendToStream("warehouseLocation", data).join();
        return CompletableFuture.completedFuture(warehouseLocation);
    }
}
