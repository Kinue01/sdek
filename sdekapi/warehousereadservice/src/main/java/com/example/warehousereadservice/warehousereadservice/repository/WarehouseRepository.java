package com.example.warehousereadservice.warehousereadservice.repository;

import com.example.warehousereadservice.warehousereadservice.model.WarehouseResponse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface WarehouseRepository extends JpaRepository<WarehouseResponse, Integer> {
}
