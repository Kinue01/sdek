package com.example.warehousereadservice.warehousereadservice.controller;

import com.example.warehousereadservice.warehousereadservice.model.WarehouseResponse;
import com.example.warehousereadservice.warehousereadservice.service.UpdateWarehouseDbService;
import com.example.warehousereadservice.warehousereadservice.service.WarehouseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

@RestController
@RequestMapping(value = "/api/warehouses", produces = "application/json")
public class WarehouseController {
    final WarehouseService service;

    @Autowired
    public WarehouseController(WarehouseService service, UpdateWarehouseDbService updateWarehouseDbService) {
        this.service = service;
        updateWarehouseDbService.init();
    }

    @GetMapping
    public WarehouseResponse getWarehouseById(@RequestParam int id) {
        try {
            CompletableFuture<WarehouseResponse> res = service.getWarehouse(id);
            return res.get();
        } catch (InterruptedException | ExecutionException e) {
            System.out.println("aaa error");
            return null;
        }
    }

    @GetMapping
    public Iterable<WarehouseResponse> getWarehouses() {
        try {
            CompletableFuture<Iterable<WarehouseResponse>> res = service.getWarehouses();
            return res.get();
        } catch (InterruptedException | ExecutionException e) {
            System.out.println("aaa error");
            return null;
        }
    }
}
