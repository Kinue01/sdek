package com.example.servicesservice.controller;

import com.example.servicesservice.model.PackageServices;
import com.example.servicesservice.service.PackageServicesService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/servicesservice/api/services")
public class PackageServicesController {
    private final PackageServicesService packageServicesService;

    public PackageServicesController(PackageServicesService packageServicesService) {
        this.packageServicesService = packageServicesService;
    }

    @PostMapping
    public PackageServices addPackageServices(PackageServices services) {
        return packageServicesService.addPackageAndServices(services).join();
    }

    @PatchMapping
    public PackageServices deletePackageServices(PackageServices services) {
        return packageServicesService.deletePackageAndServices(services).join();
    }

    @DeleteMapping
    public PackageServices updatePackageServices(PackageServices services) {
        return packageServicesService.updatePackageAndServices(services).join();
    }
}
