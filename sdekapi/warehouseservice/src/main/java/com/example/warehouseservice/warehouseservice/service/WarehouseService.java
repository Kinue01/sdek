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
    EventStoreDBClient client;

    public WarehouseService(EventStoreDBClient client) {
        this.client = client;
    }

    @Async
    public CompletableFuture<Boolean> addWarehouse(Warehouse warehouse) {
        EventData data = EventData.builderAsJson("warehouse_add", warehouse).build();
        try {
            client.appendToStream("warehouse", data).get();
            return CompletableFuture.completedFuture(true);
        } catch (ExecutionException | InterruptedException e) {
            System.out.println("err");
            return CompletableFuture.completedFuture(false);
        }
    }

    @Async
    public CompletableFuture<Boolean> updateWarehouse(Warehouse warehouse) {
        EventData data = EventData.builderAsJson("warehouse_update", warehouse).build();
        try {
            client.appendToStream("warehouse", data).get();
            return CompletableFuture.completedFuture(true);
        } catch (ExecutionException | InterruptedException e) {
            System.out.println("err");
            return CompletableFuture.completedFuture(false);
        }
    }

    @Async
    public CompletableFuture<Boolean> deleteWarehouse(Warehouse warehouse) {
        EventData data = EventData.builderAsJson("warehouse_delete", warehouse).build();
        try {
            client.appendToStream("warehouse", data).get();
            return CompletableFuture.completedFuture(true);
        } catch (ExecutionException | InterruptedException e) {
            System.out.println("err");
            return CompletableFuture.completedFuture(false);
        }
    }
}
