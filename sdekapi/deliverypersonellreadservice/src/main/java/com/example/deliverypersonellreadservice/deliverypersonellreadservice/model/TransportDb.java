package com.example.deliverypersonellreadservice.deliverypersonellreadservice.model;

import jakarta.persistence.*;
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
