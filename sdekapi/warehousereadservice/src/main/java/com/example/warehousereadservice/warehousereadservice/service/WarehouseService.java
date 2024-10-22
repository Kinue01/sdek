package com.example.warehousereadservice.warehousereadservice.service;

import com.example.warehousereadservice.warehousereadservice.model.WarehouseResponse;
import com.example.warehousereadservice.warehousereadservice.model.WarehouseType;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseRedisRepository;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseRepository;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseTypeRedisRepository;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseTypeRepository;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
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

    @Autowired
    public WarehouseService(WarehouseRepository repository, WarehouseRedisRepository redisRepository, WarehouseTypeService typeService) {
        logger.debug("Get dependency");
        this.repository = repository;
        this.redisRepository = redisRepository;
        this.typeService = typeService;
    }

    @Async
    public CompletableFuture<WarehouseResponse> getWarehouse(int id) throws InterruptedException, ExecutionException {
        logger.info("Get warehouse");
        var redis = redisRepository.findById(id);
        if (redis.isPresent()) {
            return CompletableFuture.completedFuture(
                new WarehouseResponse(
                    redis.get().getWarehouse_id(), 
                    redis.get().getWarehouse_name(), 
                    redis.get().getWarehouse_address(),
                    redis.get().getWarehouse_point(),
                    typeService.getType(redis.get().getWarehouse_type_id()).get()
                )
            );
        }

        var remote = repository.findById(id);
        if (remote.isPresent()) {
            return CompletableFuture.completedFuture(
                new WarehouseResponse(
                    remote.get().getWarehouse_id(), 
                    remote.get().getWarehouse_name(), 
                    remote.get().getWarehouse_address(),
                    remote.get().getWarehouse_point(),
                    typeService.getType(remote.get().getWarehouse_type()).get()
                )
            );
        }

        return null;
    }

    @Async
    public CompletableFuture<Iterable<WarehouseResponse>> getWarehouses() {
        logger.info("Get warehouses");
        var redis = redisRepository.findAll();
        if (redis.iterator().hasNext()) {
            ArrayList<WarehouseResponse> res = new ArrayList<>();
            redis.forEach(item -> {
                var type = typeRedisRepository.findById(item.getWarehouse_type_id());
                if (type.isPresent()) {
                    res.add(new WarehouseResponse(
                        item.getWarehouse_id(),
                        item.getWarehouse_name(),
                        item.getWarehouse_address(),
                        item.getWarehouse_point(),
                        new WarehouseType(
                            item.getWarehouse_type_id(), null, 0, 0, 0)
                ));
                }
                else {
                    var typeR = typeRepository.findById(item.getWarehouse_type_id());
                    if (typeR.isPresent()) {
                        res.add(new WarehouseResponse(
                        item.getWarehouse_id(),
                        item.getWarehouse_name(),
                        item.getWarehouse_address(),
                        item.getWarehouse_point(),
                        new WarehouseType(
                            item.getWarehouse_type_id(), null, 0, 0, 0)
                ));
                    }
                    else {
                        res.add(new WarehouseResponse(
                        item.getWarehouse_id(),
                        item.getWarehouse_name(),
                        item.getWarehouse_address(),
                        item.getWarehouse_point(),
                        new WarehouseType(
                            item.getWarehouse_type_id(), null, 0, 0, 0)
                ));
                    }
                }
            });
            return CompletableFuture.completedFuture(res);
        }
        else {
            return CompletableFuture.completedFuture(repository.findAll().iterator());
        }
    }
}
