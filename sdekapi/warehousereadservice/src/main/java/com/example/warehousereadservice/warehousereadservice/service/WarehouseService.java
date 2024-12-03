package com.example.warehousereadservice.warehousereadservice.service;

import com.example.warehousereadservice.warehousereadservice.model.WarehouseResponse;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletableFuture;

@Service
public class WarehouseService {
    private final WarehouseRepository repository;

    private final Logger logger = LoggerFactory.getLogger(WarehouseService.class);

    public WarehouseService(WarehouseRepository repository) {
        logger.debug("Get dependency");
        this.repository = repository;
    }

    @Cacheable("warehouse")
    @Async
    public CompletableFuture<WarehouseResponse> getWarehouse(int id) {
        logger.info("Get warehouse");
        return CompletableFuture.completedFuture(repository.findById(id).orElse(null));
    }

    @Cacheable("warehouses")
    @Async
    public CompletableFuture<List<WarehouseResponse>> getWarehouses() {
        logger.info("Get warehouses");
        return CompletableFuture.completedFuture(repository.findAll());
    }
}
