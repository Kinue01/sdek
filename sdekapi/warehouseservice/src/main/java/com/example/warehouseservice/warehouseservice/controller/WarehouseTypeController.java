package com.example.warehouseservice.warehouseservice.controller;

import com.example.warehouseservice.warehouseservice.model.WarehouseType;
import com.example.warehouseservice.warehouseservice.service.WarehouseTypeService;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import java.util.concurrent.ExecutionException;

@RestController
@RequestMapping(value = "/api/warehouse_type", produces = "application/json")
public class WarehouseTypeController {
    WarehouseTypeService service;

    public WarehouseTypeController(WarehouseTypeService service) {
        this.service = service;
    }

    @PostMapping
    @ResponseStatus(value = HttpStatus.CREATED)
    public void addType(WarehouseType type) {
        try {
            service.addType(type).get();
        } catch (ExecutionException | InterruptedException e) {
            System.out.println("err");
        }
    }

    @PatchMapping
    public void updateType(WarehouseType type) {
        try {
            service.updateType(type).get();
        } catch (ExecutionException | InterruptedException e) {
            System.out.println("err");
        }
    }

    @DeleteMapping
    public void deleteType(WarehouseType type) {
        try {
            service.deleteType(type).get();
        } catch (ExecutionException | InterruptedException e) {
            System.out.println("err");
        }
    }
}
