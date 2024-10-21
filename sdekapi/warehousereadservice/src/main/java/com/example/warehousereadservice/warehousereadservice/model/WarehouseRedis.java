package com.example.warehousereadservice.warehousereadservice.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.geo.Point;
import org.springframework.data.redis.core.RedisHash;

@RedisHash("warehouses")
public class WarehouseRedis {
    @Id
    int warehouse_id;

    String warehouse_name;
    String warehouse_address;
    Point warehouse_point;
    WarehouseTypeRedis warehouse_type;

    public WarehouseRedis(int warehouse_id, String warehouse_name, String warehouse_address, Point warehouse_point, WarehouseTypeRedis warehouse_type_id) {
        this.warehouse_id = warehouse_id;
        this.warehouse_name = warehouse_name;
        this.warehouse_address = warehouse_address;
        this.warehouse_point = warehouse_point;
        this.warehouse_type = warehouse_type_id;
    }

    public int getWarehouse_id() {
        return warehouse_id;
    }

    public void setWarehouse_id(int warehouse_id) {
        this.warehouse_id = warehouse_id;
    }

    public String getWarehouse_name() {
        return warehouse_name;
    }

    public void setWarehouse_name(String warehouse_name) {
        this.warehouse_name = warehouse_name;
    }

    public String getWarehouse_address() {
        return warehouse_address;
    }

    public void setWarehouse_address(String warehouse_address) {
        this.warehouse_address = warehouse_address;
    }

    public Point getWarehouse_point() {
        return warehouse_point;
    }

    public void setWarehouse_point(Point warehouse_point) {
        this.warehouse_point = warehouse_point;
    }

    public WarehouseTypeRedis getWarehouse_type_id() {
        return warehouse_type;
    }

    public void setWarehouse_type_id(WarehouseTypeRedis warehouse_type_id) {
        this.warehouse_type = warehouse_type_id;
    }
}
