package com.example.warehousereadservice.warehousereadservice.model;

public class WarehouseTypeResponse {
    int type_id;
    String type_name;
    int type_small_quantity;
    int type_med_quantity;
    int type_huge_quantity;

    public WarehouseTypeResponse(int type_id, String type_name, int type_small_quantity, int type_med_quantity, int type_huge_quantity) {
        this.type_id = type_id;
        this.type_name = type_name;
        this.type_small_quantity = type_small_quantity;
        this.type_med_quantity = type_med_quantity;
        this.type_huge_quantity = type_huge_quantity;
    }

    public int getType_id() {
        return type_id;
    }

    public void setType_id(int type_id) {
        this.type_id = type_id;
    }

    public String getType_name() {
        return type_name;
    }

    public void setType_name(String type_name) {
        this.type_name = type_name;
    }

    public int getType_small_quantity() {
        return type_small_quantity;
    }

    public void setType_small_quantity(int type_small_quantity) {
        this.type_small_quantity = type_small_quantity;
    }

    public int getType_med_quantity() {
        return type_med_quantity;
    }

    public void setType_med_quantity(int type_med_quantity) {
        this.type_med_quantity = type_med_quantity;
    }

    public int getType_huge_quantity() {
        return type_huge_quantity;
    }

    public void setType_huge_quantity(int type_huge_quantity) {
        this.type_huge_quantity = type_huge_quantity;
    }
}
