package com.example.servicesservice.controller;

import com.example.servicesservice.model.DbService;
import com.example.servicesservice.service.DbServiceService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/servicesservice/api/service")
public class ServiceController {
    private final DbServiceService dbServiceService;

    public ServiceController(DbServiceService dbServiceService) {
        this.dbServiceService = dbServiceService;
    }

    @PostMapping
    public DbService addService(@RequestBody DbService service) {
        return dbServiceService.addService(service).join();
    }

    @PatchMapping
    public DbService updateService(@RequestBody DbService service) {
        return dbServiceService.updateService(service).join();
    }

    @DeleteMapping
    public DbService deleteService(@RequestBody DbService service) {
        return dbServiceService.deleteService(service).join();
    }
}
