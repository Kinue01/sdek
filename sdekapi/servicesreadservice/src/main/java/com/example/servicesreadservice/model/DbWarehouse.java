package com.example.servicesreadservice.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.geo.Point;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "tb_fwarehouse")
public class DbWarehouse {
    @Id
    int warehouse_id;
    String warehouse_name;
    String warehouse_address;
    short warehouse_type_id;
}
