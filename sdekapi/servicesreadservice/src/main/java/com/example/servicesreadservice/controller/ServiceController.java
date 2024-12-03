package com.example.servicesreadservice.controller;

import com.example.servicesreadservice.model.DbService;
import com.example.servicesreadservice.service.DbServiceService;
import com.example.servicesreadservice.service.PackageServicesService;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/servicesreadservice/api")
public class ServiceController {
    private final DbServiceService dbServiceService;
    private final PackageServicesService packageServicesService;

    public ServiceController(DbServiceService dbServiceService, PackageServicesService packageServicesService) {
        this.dbServiceService = dbServiceService;
        this.packageServicesService = packageServicesService;
    }

    @GetMapping("/service")
    public DbService getServiceById(@RequestParam short id) {
        return dbServiceService.getServiceById(id).join();
    }

    @GetMapping("/services")
    public List<DbService> getAllServices() {
        return dbServiceService.getAllServices().join();
    }

    @GetMapping("/package_services")
    public List<DbService> getServicesByPackageId(@RequestParam UUID packageId) {
        return packageServicesService.getPackageServiceById(packageId).join().parallelStream().map(item -> dbServiceService.getServiceById(item.getService().getService_id()).join()).toList();
    }
}
