package com.example.warehousereadservice.warehousereadservice.controller;

import com.example.warehousereadservice.warehousereadservice.model.WarehouseLocation;
import com.example.warehousereadservice.warehousereadservice.service.WarehouseLocationService;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@CrossOrigin(origins = "*")
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
