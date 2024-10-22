package com.example.warehousereadservice.warehousereadservice.service;

import com.example.warehousereadservice.warehousereadservice.model.WarehouseType;
import com.example.warehousereadservice.warehousereadservice.model.WarehouseTypeRedis;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseTypeRedisRepository;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseTypeRepository;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.concurrent.CompletableFuture;

@Service
public class WarehouseTypeService {
    final WarehouseTypeRepository repository;
    final WarehouseTypeRedisRepository redisRepository;

    public WarehouseTypeService(WarehouseTypeRepository repository, WarehouseTypeRedisRepository redisRepository) {
        this.repository = repository;
        this.redisRepository = redisRepository;
    }

    @Async
    public CompletableFuture<WarehouseType> getType(int id) {
        var redis = redisRepository.findById(id);
        if (redis.isPresent()) {
            return CompletableFuture.completedFuture(new WarehouseType(
                redis.get().getType_id(), 
                redis.get().getType_name(), 
                redis.get().getType_small_quantity(), 
                redis.get().getType_med_quantity(), 
                redis.get().getType_huge_quantity()
            ));
        }

        var db = repository.findById(id);
        return db.map(CompletableFuture::completedFuture).orElse(null);
    }

    @Async
    public CompletableFuture<Iterable<WarehouseType>> getTypes() {
        var redis = (ArrayList<WarehouseTypeRedis>)redisRepository.findAll();
        if (!redis.isEmpty()) {
            var res = redis.parallelStream().map(item -> new WarehouseType(
                    item.getType_id(),
                    item.getType_name(),
                    item.getType_small_quantity(),
                    item.getType_med_quantity(),
                    item.getType_huge_quantity()
            )).toList();
            return CompletableFuture.completedFuture(res);
        }
        return CompletableFuture.completedFuture(repository.findAll());
    }
}
