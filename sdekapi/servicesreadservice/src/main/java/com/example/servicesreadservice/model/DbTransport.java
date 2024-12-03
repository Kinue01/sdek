package com.example.servicesreadservice.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "tb_ftransport")
public class DbTransport {
    @Id
    int transport_id;
    String transport_name;
    String transport_reg_number;
    short transport_type_id;
    short transport_status_id;
}
