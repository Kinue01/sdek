package com.example.warehousereadservice.warehousereadservice.repository;

import com.example.warehousereadservice.warehousereadservice.model.Warehouse;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface WarehouseRepository extends CrudRepository<Warehouse, Integer> {
}
