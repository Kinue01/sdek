package com.example.warehousereadservice.warehousereadservice.repository;

import com.arangodb.springframework.repository.ArangoRepository;
import com.example.warehousereadservice.warehousereadservice.model.WarehouseLocation;
import org.springframework.stereotype.Repository;

@Repository
public interface WarehouseLocationRepository extends ArangoRepository<WarehouseLocation, String> {
}
