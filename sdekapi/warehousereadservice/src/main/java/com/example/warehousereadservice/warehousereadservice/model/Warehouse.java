package com.example.warehousereadservice.warehousereadservice.model;

import jakarta.persistence.*;
import org.springframework.data.geo.Point;

@Entity
@Table(name = "tb_warehouse")
public class Warehouse {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    int warehouse_id;

    String warehouse_name;
    String warehouse_address;
    Point warehouse_point;
    WarehouseType warehouse_type;

    public Warehouse(int warehouse_id, String warehouse_name, String warehouse_address, Point warehouse_point, WarehouseType warehouse_type) {
        this.warehouse_id = warehouse_id;
        this.warehouse_name = warehouse_name;
        this.warehouse_address = warehouse_address;
        this.warehouse_point = warehouse_point;
        this.warehouse_type = warehouse_type;
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

    public WarehouseType getWarehouse_type() {
        return warehouse_type;
    }

    public void setWarehouse_type(WarehouseType warehouse_type) {
        this.warehouse_type = warehouse_type;
    }
}
