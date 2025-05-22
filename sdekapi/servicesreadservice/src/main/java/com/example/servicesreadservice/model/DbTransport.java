package com.example.servicesreadservice.model;

import jakarta.persistence.*;
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
    private int transport_id;
    private String transport_name;
    private String transport_reg_number;
    @ManyToOne
    @JoinColumn(name = "transport_type_id")
    private TransportType transport_type;
    @ManyToOne
    @JoinColumn(name = "transport_status_id")
    private TransportStatus transport_status;
}
