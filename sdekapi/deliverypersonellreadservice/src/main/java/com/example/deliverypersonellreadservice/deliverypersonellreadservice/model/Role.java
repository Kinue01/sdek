package com.example.deliverypersonellreadservice.deliverypersonellreadservice.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "tb_frole")
public class Role {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private short role_id;
    private String role_name;
}
