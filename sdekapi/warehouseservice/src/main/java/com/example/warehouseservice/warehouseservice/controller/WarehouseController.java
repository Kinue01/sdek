package com.example.warehouseservice.warehouseservice.controller;

import com.example.warehouseservice.warehouseservice.model.Warehouse;
import com.example.warehouseservice.warehouseservice.service.WarehouseService;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import java.util.concurrent.ExecutionException;

@RestController
@RequestMapping(path = "/api/warehouse", produces = "application/json")
public class WarehouseController {
    WarehouseService service;

    public WarehouseController(WarehouseService service) {
        this.service = service;
    }

    @PostMapping
    @ResponseStatus(value = HttpStatus.CREATED)
    public void addWarehouse(@RequestBody Warehouse warehouse) {
        try {
            service.addWarehouse(warehouse).get();
        } catch (ExecutionException | InterruptedException e) {
            System.out.println(e.getMessage());
        }
    }

    @PatchMapping
    public void updateWarehouse(@RequestBody Warehouse warehouse) {
        try {
            service.updateWarehouse(warehouse).get();
        } catch (ExecutionException | InterruptedException e) {
            System.out.println(e.getMessage());
        }
    }

    @DeleteMapping
    public void deleteWarehouse(@RequestBody Warehouse warehouse) {
        try {
            service.deleteWarehouse(warehouse).get();
        } catch (ExecutionException | InterruptedException e) {
            System.out.println(e.getMessage());
        }
    }
}
