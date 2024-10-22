package com.example.warehousereadservice.warehousereadservice.controller;

import com.example.warehousereadservice.warehousereadservice.model.WarehouseType;
import com.example.warehousereadservice.warehousereadservice.service.UpdateWarehouseTypeDbService;
import com.example.warehousereadservice.warehousereadservice.service.WarehouseTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.concurrent.ExecutionException;

@RestController
@RequestMapping(value = "/api/warehouse_types", produces = "application/json")
public class WarehouseTypeController {
    final WarehouseTypeService service;
    final UpdateWarehouseTypeDbService updateWarehouseTypeDbService;

    @Autowired
    public WarehouseTypeController(WarehouseTypeService service, UpdateWarehouseTypeDbService updateWarehouseTypeDbService) {
        this.service = service;
        this.updateWarehouseTypeDbService = updateWarehouseTypeDbService;
        this.updateWarehouseTypeDbService.init();
    }

    @GetMapping
    public WarehouseType getTypeById(@RequestParam int id) {
        var res = service.getType(id);
        try {
            return res.get();
        } catch (InterruptedException | ExecutionException e) {
            System.out.println("err");
            return null;
        }
    }

    @GetMapping
    public Iterable<WarehouseType> getTypes() {
        var res = service.getTypes();
        try {
            return res.get();
        } catch (InterruptedException | ExecutionException e) {
            System.out.println("err");
            return null;
        }
    }
}
