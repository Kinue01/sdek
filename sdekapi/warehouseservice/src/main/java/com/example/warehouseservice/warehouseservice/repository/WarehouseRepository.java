package com.example.warehouseservice.warehouseservice.repository;

import com.example.warehouseservice.warehouseservice.model.Warehouse;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

public interface WarehouseRepository {
    CompletableFuture<Boolean> addWarehouse(Warehouse warehouse) throws ExecutionException, InterruptedException;
    CompletableFuture<Boolean> updateWarehouse(Warehouse warehouse) throws ExecutionException, InterruptedException;
    CompletableFuture<Boolean> deleteWarehouse(Warehouse warehouse) throws ExecutionException, InterruptedException;
}
