package com.example.warehousereadservice.warehousereadservice.controller;

import com.example.warehousereadservice.warehousereadservice.model.WarehouseType;
import com.example.warehousereadservice.warehousereadservice.service.UpdateWarehouseTypeDbService;
import com.example.warehousereadservice.warehousereadservice.service.WarehouseTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

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
        this.updateWarehouseTypeDbService.init();
    }

    @GetMapping("/{id}")
    @ResponseBody
    public WarehouseType getTypeById(@PathVariable int id) throws ExecutionException, InterruptedException {
        var res = service.getType(id);
        return res.get();
    }

    @GetMapping
    @ResponseBody
    public Iterable<WarehouseType> getTypes() throws ExecutionException, InterruptedException {
        var res = service.getTypes();
        return res.get();
    }
}
