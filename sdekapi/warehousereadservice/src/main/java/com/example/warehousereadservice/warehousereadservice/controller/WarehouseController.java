package com.example.warehousereadservice.warehousereadservice.controller;

import com.example.warehousereadservice.warehousereadservice.model.Warehouse;
import com.example.warehousereadservice.warehousereadservice.service.UpdateWarehouseDbService;
import com.example.warehousereadservice.warehousereadservice.service.WarehouseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.Optional;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

@RestController
@RequestMapping("/warehouses")
public class WarehouseController {
    final WarehouseService service;
    final UpdateWarehouseDbService updateWarehouseDbService;

    @Autowired
    public WarehouseController(WarehouseService service, UpdateWarehouseDbService updateWarehouseDbService) {
        this.service = service;
        this.updateWarehouseDbService = updateWarehouseDbService;
        this.updateWarehouseDbService.init();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Warehouse> getWarehouseById(@PathVariable int id) throws ExecutionException, InterruptedException {
        CompletableFuture<Optional<Warehouse>> res = service.getWarehouse(id);
        return ResponseEntity.ok(res.get().get());
    }

    @GetMapping
    public ResponseEntity<Iterable<Warehouse>> getWarehouses() throws ExecutionException, InterruptedException {
        CompletableFuture<Iterable<Warehouse>> res = service.getWarehouses();
        return ResponseEntity.ok(res.get());
    }
}
