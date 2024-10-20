package com.example.warehousereadservice.warehousereadservice.repository;

import com.example.warehousereadservice.warehousereadservice.model.WarehouseType;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface WarehouseTypeRepository extends CrudRepository<WarehouseType, Integer> {
}
