package com.example.warehousereadservice.warehousereadservice.controller;

import com.example.warehousereadservice.warehousereadservice.model.WarehouseLocation;
import com.example.warehousereadservice.warehousereadservice.service.WarehouseLocationService;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping(value = "/warehousereadservice/api", produces = MediaType.APPLICATION_JSON_VALUE)
public class WarehouseLocationController {
    private final WarehouseLocationService warehouseLocationService;

    public WarehouseLocationController(WarehouseLocationService warehouseLocationService) {
        this.warehouseLocationService = warehouseLocationService;
    }

    @GetMapping("/warehouseLocations")
    public Iterable<WarehouseLocation> getWarehouseLocations() {
        return warehouseLocationService.getAllWarehouseLocations();
    }

    @GetMapping("/warehouseLocation")
    public WarehouseLocation getWarehouseLocationById(@RequestParam("id") String id) {
        return warehouseLocationService.getWarehouseLocationById(id);
    }
}
