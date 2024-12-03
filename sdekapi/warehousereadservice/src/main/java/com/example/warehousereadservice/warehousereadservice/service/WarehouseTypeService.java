package com.example.warehousereadservice.warehousereadservice.service;

import com.example.warehousereadservice.warehousereadservice.model.WarehouseType;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseTypeRepository;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CompletableFuture;

@Service
public class WarehouseTypeService {
    private final WarehouseTypeRepository repository;

    public WarehouseTypeService(WarehouseTypeRepository repository) {
        this.repository = repository;
    }

    @Cacheable("warehouse_type")
    @Async
    public CompletableFuture<WarehouseType> getType(short id) {
        return CompletableFuture.completedFuture(repository.findById(id).orElse(null));
    }

    @Cacheable("warehouse_types")
    @Async
    public CompletableFuture<List<WarehouseType>> getTypes() {
        return CompletableFuture.completedFuture(repository.findAll());
    }
}
