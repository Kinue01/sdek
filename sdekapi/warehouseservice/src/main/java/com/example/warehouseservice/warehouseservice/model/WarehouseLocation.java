package com.example.warehouseservice.warehouseservice.model;

import com.mongodb.client.model.geojson.Point;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class WarehouseLocation {
    private String id;
    private Point location;
}
