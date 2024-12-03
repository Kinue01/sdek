package com.example.warehousereadservice.warehousereadservice.model;

import com.arangodb.springframework.annotation.ArangoId;
import com.arangodb.springframework.annotation.Document;
import com.arangodb.springframework.annotation.GeoIndexed;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.geo.Point;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Document("warehouseLocations")
public class WarehouseLocation {
    @Id
    String key;
    @ArangoId
    String warehouseId;
    @GeoIndexed(geoJson = true)
    Point location;
}
