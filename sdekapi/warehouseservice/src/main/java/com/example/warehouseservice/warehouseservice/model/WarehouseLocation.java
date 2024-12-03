package com.example.warehouseservice.warehouseservice.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.geo.Point;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class WarehouseLocation {
    String key;
    String warehouseId;
    Point location;
}
