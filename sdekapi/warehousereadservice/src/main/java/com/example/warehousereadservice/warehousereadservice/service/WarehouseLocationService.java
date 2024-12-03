package com.example.warehousereadservice.warehousereadservice.service;

import com.example.warehousereadservice.warehousereadservice.model.WarehouseLocation;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseLocationRepository;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.concurrent.CompletableFuture;

@Service
public class WarehouseLocationService {
    private final WarehouseLocationRepository warehouseLocationRepository;

    public WarehouseLocationService(WarehouseLocationRepository warehouseLocationRepository) {
        this.warehouseLocationRepository = warehouseLocationRepository;
    }

    @Async
    @Cacheable("warehouseLocations")
    public CompletableFuture<Iterable<WarehouseLocation>> getAllWarehouseLocations() {
        return CompletableFuture.completedFuture(warehouseLocationRepository.findAll());
    }

    @Async
    @Cacheable("warehouseLoc")
    public CompletableFuture<WarehouseLocation> getWarehouseLocationById(String id) {
        return CompletableFuture.completedFuture(warehouseLocationRepository.findById(id).orElse(null));
    }
}
