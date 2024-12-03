package com.example.deliverypersonellreadservice.deliverypersonellreadservice.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "tb_ftransport")
public class TransportDb {
    @Id
    int transport_id;
    String transport_name;
    String transport_reg_number;
    short transport_type_id;
    short transport_status_id;
}
