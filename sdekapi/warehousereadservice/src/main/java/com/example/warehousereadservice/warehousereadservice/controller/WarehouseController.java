package com.example.warehousereadservice.warehousereadservice.controller;

import com.example.warehousereadservice.warehousereadservice.model.WarehouseResponse;
import com.example.warehousereadservice.warehousereadservice.service.WarehouseService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping(value = "/warehousereadservice/api", produces = "application/json")
public class WarehouseController {
    private final WarehouseService service;

    public WarehouseController(WarehouseService service) {
        this.service = service;
    }

    @GetMapping("/warehouse")
    public WarehouseResponse getWarehouseById(@RequestParam int id) {
        return service.getWarehouse(id).join();
    }

    @GetMapping("/warehouses")
    public List<WarehouseResponse> getWarehouses() {
        return service.getWarehouses().join();
    }
}
