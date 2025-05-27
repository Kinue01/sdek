package com.example.servicesreadservice.service;

import com.example.servicesreadservice.model.DbPackage;
import com.example.servicesreadservice.model.DbService;
import com.example.servicesreadservice.repository.PackageRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
public class PackageServicesService {
    private final PackageRepository packageRepository;

    public PackageServicesService(PackageRepository packageRepository) {
        this.packageRepository = packageRepository;
    }

    public List<DbService> getPackageServiceById(UUID id) {
        DbPackage dbPackage = packageRepository.findById(id).orElse(null);
        assert dbPackage != null;
        return dbPackage.getPackage_services();
    }
}
