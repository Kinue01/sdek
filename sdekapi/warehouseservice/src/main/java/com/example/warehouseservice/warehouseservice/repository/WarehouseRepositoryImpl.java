package com.example.warehouseservice.warehouseservice.repository;

import com.eventstore.dbclient.EventData;
import com.eventstore.dbclient.EventStoreDBClient;
import com.example.warehouseservice.warehouseservice.model.Warehouse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

@Service
public class WarehouseRepositoryImpl implements WarehouseRepository {
    EventStoreDBClient client;

    @Autowired
    public WarehouseRepositoryImpl(EventStoreDBClient client) {
        this.client = client;
    }

    @Async
    @Override
    public CompletableFuture<Boolean> addWarehouse(Warehouse warehouse) throws ExecutionException, InterruptedException {
        EventData data = EventData.builderAsJson("warehouse_add", warehouse).build();
        client.appendToStream("warehouse", data).get();
        return CompletableFuture.completedFuture(true);
    }

    @Async
    @Override
    public CompletableFuture<Boolean> updateWarehouse(Warehouse warehouse) throws ExecutionException, InterruptedException {
        EventData data = EventData.builderAsJson("warehouse_update", warehouse).build();
        client.appendToStream("warehouse", data).get();
        return CompletableFuture.completedFuture(true);
    }

    @Async
    @Override
    public CompletableFuture<Boolean> deleteWarehouse(Warehouse warehouse) throws ExecutionException, InterruptedException {
        EventData data = EventData.builderAsJson("warehouse_delete", warehouse).build();
        client.appendToStream("warehouse", data).get();
        return CompletableFuture.completedFuture(true);
    }
}
