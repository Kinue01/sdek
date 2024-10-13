package com.example.warehouseservice.warehouseservice.repository;

import com.eventstore.dbclient.EventData;
import com.eventstore.dbclient.EventStoreDBClient;
import com.eventstore.dbclient.WriteResult;
import com.example.warehouseservice.warehouseservice.model.Warehouse;
import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.AsyncResult;
import org.springframework.stereotype.Repository;

import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;

@Repository
public class WarehouseRepositoryImpl implements WarehouseRepository {

    EventStoreDBClient client;

    public WarehouseRepositoryImpl(EventStoreDBClient client) {
        this.client = client;
    }

    @Override
    public boolean addWarehouse(Warehouse warehouse) throws ExecutionException, InterruptedException {
        EventData data = EventData.builderAsJson("warehouse_add", warehouse).build();
        client.appendToStream("warehouse", data).get();
        return true;
    }

    @Override
    public boolean updateWarehouse(Warehouse warehouse) throws ExecutionException, InterruptedException {
        EventData data = EventData.builderAsJson("warehouse_update", warehouse).build();
        client.appendToStream("warehouse", data).get();
        return true;
    }

    @Override
    public boolean deleteWarehouse(Warehouse warehouse) throws ExecutionException, InterruptedException {
        EventData data = EventData.builderAsJson("warehouse_delete", warehouse).build();
        client.appendToStream("warehouse", data).get();
        return true;
    }
}
