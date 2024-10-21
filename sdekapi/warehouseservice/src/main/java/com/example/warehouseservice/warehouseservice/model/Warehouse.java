package com.example.warehouseservice.warehouseservice.model;

import lombok.Data;
import org.springframework.data.geo.Point;

@Data
public class Warehouse {
    public int warehouse_id;
    public String warehouse_name;
    public String warehouse_address;
    public Point warehouse_point;
    public WarehouseType warehouse_type;
}
