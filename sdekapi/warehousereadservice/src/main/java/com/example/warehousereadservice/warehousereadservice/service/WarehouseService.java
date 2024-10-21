package com.example.warehousereadservice.warehousereadservice.service;

import com.example.warehousereadservice.warehousereadservice.model.Warehouse;
import com.example.warehousereadservice.warehousereadservice.model.WarehouseType;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseRedisRepository;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.Optional;
import java.util.concurrent.CompletableFuture;

@Service
public class WarehouseService {
    final WarehouseRepository repository;
    final WarehouseRedisRepository redisRepository;
    Logger logger = LoggerFactory.getLogger(WarehouseService.class);

    @Autowired
    public WarehouseService(WarehouseRepository repository, WarehouseRedisRepository redisRepository) {
        logger.debug("Get dependency");
        this.repository = repository;
        this.redisRepository = redisRepository;
    }

    @Async
    public CompletableFuture<Optional<Warehouse>> getWarehouse(int id) {
        logger.info("Get warehouse");
        var redis = redisRepository.findById(id);
        if (redis.isPresent()){
            var res = redis.get();
            return CompletableFuture.completedFuture(Optional.of(new Warehouse(res.getWarehouse_id(),
                    res.getWarehouse_name(),
                    res.getWarehouse_address(),
                    res.getWarehouse_point(),
                    new WarehouseType(
                            res.getWarehouse_type_id().getType_id(),
                            res.getWarehouse_type_id().getType_name(),
                            res.getWarehouse_type_id().getType_small_quantity(),
                            res.getWarehouse_type_id().getType_med_quantity(),
                            res.getWarehouse_type_id().getType_huge_quantity()
                    ))));
        }
        else {
            return CompletableFuture.completedFuture(repository.findById(id));
        }

    }

    @Async
    public CompletableFuture<Iterable<Warehouse>> getWarehouses() {
        logger.info("Get warehouses");
        var redis = redisRepository.findAll();
        if (redis != null) {
            ArrayList<Warehouse> res = new ArrayList<>();
            redis.forEach(item -> {
                res.add(new Warehouse(
                        item.getWarehouse_id(),
                        item.getWarehouse_name(),
                        item.getWarehouse_address(),
                        item.getWarehouse_point(),
                        new WarehouseType(
                                item.getWarehouse_type_id().getType_id(),
                                item.getWarehouse_type_id().getType_name(),
                                item.getWarehouse_type_id().getType_small_quantity(),
                                item.getWarehouse_type_id().getType_med_quantity(),
                                item.getWarehouse_type_id().getType_huge_quantity()
                        )
                ));
            });
            return CompletableFuture.completedFuture(res);
        }
        else {
            return CompletableFuture.completedFuture(repository.findAll());
        }
    }
}
