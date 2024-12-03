package com.example.servicesreadservice.service;

import com.example.servicesreadservice.mapper.PackageServicesToResponseMapper;
import com.example.servicesreadservice.model.PackageServiceResponse;
import com.example.servicesreadservice.repository.PackageServiceRepository;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;

@Service
public class PackageServicesService {
    private final PackageServiceRepository repository;
    private final PackageServicesToResponseMapper mapper;

    public PackageServicesService(PackageServiceRepository repository, PackageServicesToResponseMapper mapper) {
        this.repository = repository;
        this.mapper = mapper;
    }

    @Cacheable("package_services")
    @Async
    public CompletableFuture<List<PackageServiceResponse>> getPackageServiceById(UUID id) {
        return CompletableFuture.completedFuture(repository.findAll().parallelStream().filter(item -> item.getPackage_id() == id).map(mapper::map).toList());
    }

    @Cacheable("all_package_services")
    @Async
    public CompletableFuture<List<PackageServiceResponse>> getAllPackageService() {
        return CompletableFuture.completedFuture(repository.findAll().parallelStream().map(mapper::map).toList());
    }
}
