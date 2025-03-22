package com.example.warehousereadservice.warehousereadservice.repository;

import com.example.warehousereadservice.warehousereadservice.model.WarehouseLocation;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface WarehouseLocationRepository extends MongoRepository<WarehouseLocation, String> {
}
