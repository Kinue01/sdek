package com.example.servicesreadservice.service;

import com.example.servicesreadservice.model.DbService;
import com.example.servicesreadservice.repository.ServiceRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DbServiceService {
    private final ServiceRepository repository;

    public DbServiceService(ServiceRepository repository) {
        this.repository = repository;
    }

    public DbService getServiceById(short id) {
        return repository.findById(id).orElse(null);
    }

    public List<DbService> getAllServices() {
        return repository.findAll();
    }
}
