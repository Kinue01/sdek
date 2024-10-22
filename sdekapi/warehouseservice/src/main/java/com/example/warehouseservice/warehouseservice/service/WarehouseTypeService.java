package com.example.warehouseservice.warehouseservice.service;

import com.eventstore.dbclient.EventData;
import com.eventstore.dbclient.EventStoreDBClient;
import com.example.warehouseservice.warehouseservice.model.Warehouse;
import com.example.warehouseservice.warehouseservice.model.WarehouseType;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

@Service
public class WarehouseTypeService {
    EventStoreDBClient client;

    public WarehouseTypeService(EventStoreDBClient client) {
        this.client = client;
    }

    @Async
    public CompletableFuture<Boolean> addType(WarehouseType type) {
        EventData data = EventData.builderAsJson("warehouse_type_add", type).build();
        try {
            client.appendToStream("warehouse_type", data).get();
            return CompletableFuture.completedFuture(true);
        } catch (ExecutionException | InterruptedException e) {
            System.out.println("err");
            return CompletableFuture.completedFuture(false);
        }
    }

    @Async
    public CompletableFuture<Boolean> updateType(WarehouseType type) {
        EventData data = EventData.builderAsJson("warehouse_type_update", type).build();
        try {
            client.appendToStream("warehouse_type", data).get();
            return CompletableFuture.completedFuture(true);
        } catch (ExecutionException | InterruptedException e) {
            System.out.println("err");
            return CompletableFuture.completedFuture(false);
        }
    }

    @Async
    public CompletableFuture<Boolean> deleteType(WarehouseType type) {
        EventData data = EventData.builderAsJson("warehouse_type_delete", type).build();
        try {
            client.appendToStream("warehouse_type", data).get();
            return CompletableFuture.completedFuture(true);
        } catch (ExecutionException | InterruptedException e) {
            System.out.println("err");
            return CompletableFuture.completedFuture(false);
        }
    }
}
