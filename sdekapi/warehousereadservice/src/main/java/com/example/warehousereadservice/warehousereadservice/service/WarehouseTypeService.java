package com.example.warehousereadservice.warehousereadservice.service;

import com.example.warehousereadservice.warehousereadservice.model.WarehouseType;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseTypeRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class WarehouseTypeService {
    private final WarehouseTypeRepository repository;

    public WarehouseTypeService(WarehouseTypeRepository repository) {
        this.repository = repository;
    }

    public WarehouseType getType(short id) {
        return repository.findById(id).orElse(null);
    }

    public List<WarehouseType> getTypes() {
        return repository.findAll();
    }
}
