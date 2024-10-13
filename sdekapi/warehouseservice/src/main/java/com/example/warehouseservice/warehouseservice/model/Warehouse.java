package com.example.warehouseservice.warehouseservice.model;

import io.lettuce.core.GeoCoordinates;
import lombok.Data;

@Data
public class Warehouse {
    public int warehouse_id;
    public String warehouse_name;
    public String warehouse_address;
    public GeoCoordinates warehouse_point;
    public WarehouseType warehouse_type;
}
