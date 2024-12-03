package com.example.deliverypersonellreadservice.deliverypersonellreadservice.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "tb_ftransport_type")
public class TransportType {
    @Id
    short type_id;
    String type_name;
}
