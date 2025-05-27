package com.example.warehousereadservice.warehousereadservice.service;

import com.example.warehousereadservice.warehousereadservice.model.WarehouseLocation;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseLocationRepository;
import org.springframework.stereotype.Service;

@Service
public class WarehouseLocationService {
    private final WarehouseLocationRepository warehouseLocationRepository;

    public WarehouseLocationService(WarehouseLocationRepository warehouseLocationRepository) {
        this.warehouseLocationRepository = warehouseLocationRepository;
    }

    public Iterable<WarehouseLocation> getAllWarehouseLocations() {
        return warehouseLocationRepository.findAll();
    }

    public WarehouseLocation getWarehouseLocationById(String id) {
        return warehouseLocationRepository.findById(id).orElse(null);
    }
}
