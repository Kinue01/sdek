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

    @Cacheable("warehouseLocations")
    public Iterable<WarehouseLocation> getAllWarehouseLocations() {
        return warehouseLocationRepository.findAll();
    }

    @Cacheable("warehouseLoc")
    public WarehouseLocation getWarehouseLocationById(String id) {
        return warehouseLocationRepository.findById(id).orElse(null);
    }
}
