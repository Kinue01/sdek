package com.example.servicesreadservice.service;

import com.example.servicesreadservice.model.DbService;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import com.example.servicesreadservice.repository.ServiceRepository;

import java.util.List;
import java.util.concurrent.CompletableFuture;

@Service
public class DbServiceService {
    private final ServiceRepository repository;

    public DbServiceService(ServiceRepository repository) {
        this.repository = repository;
    }

    @Cacheable("service")
    public DbService getServiceById(short id) {
        return repository.findById(id).orElse(null);
    }

    @Cacheable("services")
    public List<DbService> getAllServices() {
        return repository.findAll();
    }
}
