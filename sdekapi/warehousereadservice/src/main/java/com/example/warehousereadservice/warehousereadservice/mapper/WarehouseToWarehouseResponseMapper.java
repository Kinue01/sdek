package com.example.warehousereadservice.warehousereadservice.mapper;

import com.example.warehousereadservice.warehousereadservice.model.Warehouse;
import com.example.warehousereadservice.warehousereadservice.model.WarehouseResponse;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseTypeRepository;
import org.springframework.stereotype.Component;

@Deprecated
@Component
public class WarehouseToWarehouseResponseMapper {
    private final WarehouseTypeRepository repository;

    public WarehouseToWarehouseResponseMapper(WarehouseTypeRepository repository) {
        this.repository = repository;
    }

    public WarehouseResponse map(Warehouse warehouse) {
        WarehouseResponse warehouseResponse = new WarehouseResponse();
        warehouseResponse.setWarehouse_id(warehouse.getWarehouse_id());
        warehouseResponse.setWarehouse_name(warehouse.getWarehouse_name());
        warehouseResponse.setWarehouse_address(warehouse.getWarehouse_address());
        warehouseResponse.setWarehouse_type(repository.findById(warehouse.getWarehouse_type_id()).orElse(null));
        return warehouseResponse;
    }
}
