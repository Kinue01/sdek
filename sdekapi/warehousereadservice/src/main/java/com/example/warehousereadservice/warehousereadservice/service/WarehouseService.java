package com.example.warehousereadservice.warehousereadservice.service;

import com.example.warehousereadservice.warehousereadservice.model.Warehouse;
import com.example.warehousereadservice.warehousereadservice.model.WarehouseRedis;
import com.example.warehousereadservice.warehousereadservice.model.WarehouseResponse;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseRedisRepository;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

@Service
public class WarehouseService {
    final WarehouseRepository repository;
    final WarehouseRedisRepository redisRepository;
    final WarehouseTypeService typeService;
    Logger logger = LoggerFactory.getLogger(WarehouseService.class);

    public WarehouseService(WarehouseRepository repository, WarehouseRedisRepository redisRepository, WarehouseTypeService typeService) {
        logger.debug("Get dependency");

        this.repository = repository;
        this.redisRepository = redisRepository;
        this.typeService = typeService;
    }

    @Async
    public CompletableFuture<WarehouseResponse> getWarehouse(int id) {
        logger.info("Get warehouse");

        var redis = redisRepository.findById(id);
        if (redis.isPresent()) {
            try {
                return CompletableFuture.completedFuture(
                    new WarehouseResponse(
                        redis.get().getWarehouse_id(),
                        redis.get().getWarehouse_name(),
                        redis.get().getWarehouse_address(),
                        redis.get().getWarehouse_point(),
                        typeService.getType(redis.get().getWarehouse_type_id()).get()
                    )
                );
            } catch (InterruptedException | ExecutionException e) {
                System.out.println("error");
                return null;
            }
        }

        var remote = repository.findById(id);
        if (remote.isPresent()) {
            try {
                return CompletableFuture.completedFuture(
                    new WarehouseResponse(
                        remote.get().getWarehouse_id(),
                        remote.get().getWarehouse_name(),
                        remote.get().getWarehouse_address(),
                        remote.get().getWarehouse_point(),
                        typeService.getType(remote.get().getWarehouse_type()).get()
                    )
                );
            } catch (InterruptedException | ExecutionException e) {
                System.out.println("error");
                return null;
            }
        }

        return null;
    }

    @Async
    public CompletableFuture<Iterable<WarehouseResponse>> getWarehouses() {
        logger.info("Get warehouses");

        var redis = (ArrayList<WarehouseRedis>)redisRepository.findAll();
        if (!redis.isEmpty()) {
            var res = redis.parallelStream().map(item -> {
                try {
                    return new WarehouseResponse(
                            item.getWarehouse_id(),
                            item.getWarehouse_name(),
                            item.getWarehouse_address(),
                            item.getWarehouse_point(),
                            typeService.getType(item.getWarehouse_type_id()).get()
                    );
                } catch (InterruptedException | ExecutionException e) {
                    throw new RuntimeException(e);
                }
            }).toList();
            return CompletableFuture.completedFuture(res);
        }

        var remote = (ArrayList<Warehouse>)repository.findAll();
        if (!remote.isEmpty()) {
            var res = remote.parallelStream().map(item -> {
                try {
                    return new WarehouseResponse(
                            item.getWarehouse_id(),
                            item.getWarehouse_name(),
                            item.getWarehouse_address(),
                            item.getWarehouse_point(),
                            typeService.getType(item.getWarehouse_type()).get()
                    );
                } catch (ExecutionException | InterruptedException e) {
                    throw new RuntimeException(e);
                }
            }).toList();
            return CompletableFuture.completedFuture(res);
        }

        return null;
    }
}
