package com.example.warehouseservice.warehouseservice.controller;

import com.example.warehouseservice.warehouseservice.model.Warehouse;
import com.example.warehouseservice.warehouseservice.repository.WarehouseRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.concurrent.ExecutionException;

@RestController
@RequestMapping(path = "/api", produces = "application/json")
@CrossOrigin(origins = "*")
public class WarehouseController {

    WarehouseRepository repository;

    @Autowired
    public WarehouseController(WarehouseRepository repository) {
        this.repository = repository;
    }

    @PostMapping(path = "/warehouse")
    public boolean addWarehouse(@RequestBody Warehouse warehouse) {
        boolean res = false;
        try {
            res = repository.addWarehouse(warehouse);
        } catch (ExecutionException | InterruptedException e) {
            System.out.println(e.getMessage());
        }
        return res;
    }

    @PatchMapping(path = "/warehouse")
    public boolean updateWarehouse(@RequestBody Warehouse warehouse) {
        boolean res = false;
        try {
            res = repository.updateWarehouse(warehouse);
        } catch (ExecutionException | InterruptedException e) {
            System.out.println(e.getMessage());
        }
        return res;
    }

    @DeleteMapping(path = "/warehouse")
    public boolean deleteWarehouse(@RequestBody Warehouse warehouse) {
        boolean res = false;
        try {
            res = repository.deleteWarehouse(warehouse);
        } catch (ExecutionException | InterruptedException e) {
            System.out.println(e.getMessage());
        }
        return res;
    }
}
