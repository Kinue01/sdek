package com.example.warehousereadservice.warehousereadservice.service;

import com.example.warehousereadservice.warehousereadservice.model.WarehouseType;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseTypeRepository;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.concurrent.CompletableFuture;

@Service
public class WarehouseTypeService {
    final WarehouseTypeRepository repository;

    public WarehouseTypeService(WarehouseTypeRepository repository) {
        this.repository = repository;
    }

    @Async
    public CompletableFuture<WarehouseType> getType(int id) {
        return CompletableFuture.completedFuture(repository.findById(id).get());
    }

    @Async
    public CompletableFuture<Iterable<WarehouseType>> getTypes() {
        return CompletableFuture.completedFuture(repository.findAll());
    }
}
