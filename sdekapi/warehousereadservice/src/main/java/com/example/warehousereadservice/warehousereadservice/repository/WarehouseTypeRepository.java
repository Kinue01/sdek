package com.example.warehousereadservice.warehousereadservice.repository;

import com.example.warehousereadservice.warehousereadservice.model.WarehouseType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface WarehouseTypeRepository extends JpaRepository<WarehouseType, Short> {
}
