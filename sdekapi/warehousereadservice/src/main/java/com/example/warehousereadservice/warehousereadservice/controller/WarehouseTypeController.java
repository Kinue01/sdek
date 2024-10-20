package com.example.warehousereadservice.warehousereadservice.controller;

import com.example.warehousereadservice.warehousereadservice.model.WarehouseType;
import com.example.warehousereadservice.warehousereadservice.service.UpdateWarehouseTypeDbService;
import com.example.warehousereadservice.warehousereadservice.service.WarehouseTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.concurrent.ExecutionException;

@RestController
@RequestMapping("/warehouse_types")
public class WarehouseTypeController {
    final WarehouseTypeService service;
    final UpdateWarehouseTypeDbService updateWarehouseTypeDbService;

    @Autowired
    public WarehouseTypeController(WarehouseTypeService service, UpdateWarehouseTypeDbService updateWarehouseTypeDbService) {
        this.service = service;
        this.updateWarehouseTypeDbService = updateWarehouseTypeDbService;
    }

    @GetMapping("/{id}")
    public ResponseEntity<WarehouseType> getTypeById(@PathVariable int id) throws ExecutionException, InterruptedException {
        var res = service.getType(id);
        return ResponseEntity.ok(res.get());
    }

    @GetMapping
    public ResponseEntity<Iterable<WarehouseType>> getTypes() throws ExecutionException, InterruptedException {
        var res = service.getTypes();
        return ResponseEntity.ok(res.get());
    }
}
