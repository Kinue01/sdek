package com.example.warehouseservice.warehouseservice.repository;

import com.example.warehouseservice.warehouseservice.model.Warehouse;

import java.util.concurrent.ExecutionException;

public interface WarehouseRepository {
    boolean addWarehouse(Warehouse warehouse) throws ExecutionException, InterruptedException;
    boolean updateWarehouse(Warehouse warehouse) throws ExecutionException, InterruptedException;
    boolean deleteWarehouse(Warehouse warehouse) throws ExecutionException, InterruptedException;
}
