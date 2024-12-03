package com.example.warehouseservice.warehouseservice.controller;

import com.example.warehouseservice.warehouseservice.model.WarehouseLocation;
import com.example.warehouseservice.warehouseservice.service.WarehouseLocationService;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping(value = "/warehouseservice/api/warehouseLocations", produces = MediaType.APPLICATION_JSON_VALUE)
public class WarehouseLocationController {
    private final WarehouseLocationService warehouseLocationService;

    public WarehouseLocationController(WarehouseLocationService warehouseLocationService) {
        this.warehouseLocationService = warehouseLocationService;
    }

    @PostMapping
    public WarehouseLocation add(WarehouseLocation warehouseLocation) {
        return warehouseLocationService.addWarehouseLocation(warehouseLocation).join();
    }

    @PatchMapping
    public WarehouseLocation update(WarehouseLocation warehouseLocation) {
        return warehouseLocationService.updateWarehouseLocation(warehouseLocation).join();
    }

    @DeleteMapping
    public WarehouseLocation delete(WarehouseLocation warehouseLocation) {
        return warehouseLocationService.deleteWarehouseLocation(warehouseLocation).join();
    }
}
