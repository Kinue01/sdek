package com.example.warehouseservice.warehouseservice.controller;

import com.example.warehouseservice.warehouseservice.model.Warehouse;
import com.example.warehouseservice.warehouseservice.repository.WarehouseRepositoryImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.concurrent.ExecutionException;

@RestController
@RequestMapping(path = "/api", produces = "application/json")
public class WarehouseController {
    WarehouseRepositoryImpl repository;

    @Autowired
    public WarehouseController(WarehouseRepositoryImpl repository) {
        this.repository = repository;
    }

    @PostMapping(path = "/warehouse")
    public boolean addWarehouse(@RequestBody Warehouse warehouse) {
        boolean res = false;
        try {
            res = repository.addWarehouse(warehouse).get();
        } catch (ExecutionException | InterruptedException e) {
            System.out.println(e.getMessage());
        }
        return res;
    }

    @PatchMapping(path = "/warehouse")
    @ResponseBody
    public boolean updateWarehouse(@RequestBody Warehouse warehouse) {
        boolean res = false;
        try {
            res = repository.updateWarehouse(warehouse).get();
        } catch (ExecutionException | InterruptedException e) {
            System.out.println(e.getMessage());
        }
        return res;
    }

    @DeleteMapping(path = "/warehouse")
    @ResponseBody
    public boolean deleteWarehouse(@RequestBody Warehouse warehouse) {
        boolean res = false;
        try {
            res = repository.deleteWarehouse(warehouse).get();
        } catch (ExecutionException | InterruptedException e) {
            System.out.println(e.getMessage());
        }
        return res;
    }
}
