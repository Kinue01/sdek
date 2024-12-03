package com.example.warehousereadservice.warehousereadservice.controller;

import com.example.warehousereadservice.warehousereadservice.model.WarehouseType;
import com.example.warehousereadservice.warehousereadservice.service.UpdateWarehouseTypeDbService;
import com.example.warehousereadservice.warehousereadservice.service.WarehouseTypeService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(value = "/warehousereadservice/api", produces = "application/json")
public class WarehouseTypeController {
    final WarehouseTypeService service;

    public WarehouseTypeController(WarehouseTypeService service) {
        this.service = service;
    }

    @GetMapping("/warehouse_type")
    public WarehouseType getTypeById(@RequestParam short id) {
        return service.getType(id).join();
    }

    @GetMapping("/warehouse_types")
    public List<WarehouseType> getTypes() {
        return service.getTypes().join();
    }
}
