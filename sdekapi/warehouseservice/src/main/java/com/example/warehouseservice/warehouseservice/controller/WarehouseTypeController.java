package com.example.warehouseservice.warehouseservice.controller;

import com.example.warehouseservice.warehouseservice.model.WarehouseType;
import com.example.warehouseservice.warehouseservice.service.WarehouseTypeService;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping(value = "/warehouseservice/api/warehouse_type", produces = "application/json")
public class WarehouseTypeController {
    private final WarehouseTypeService service;

    public WarehouseTypeController(WarehouseTypeService service) {
        this.service = service;
    }

    @PostMapping
    @ResponseStatus(value = HttpStatus.CREATED)
    public WarehouseType addType(WarehouseType type) {
        return service.addType(type);
    }

    @PatchMapping
    public WarehouseType updateType(WarehouseType type) {
        return service.updateType(type);
    }

    @DeleteMapping
    public WarehouseType deleteType(WarehouseType type) {
        return service.deleteType(type);
    }
}
