package com.example.deliverypersonellreadservice.deliverypersonellreadservice.repository;

import com.example.deliverypersonellreadservice.deliverypersonellreadservice.model.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface DeliveryPersonRepository extends JpaRepository<DeliveryPerson, Integer> {

    @Query(value = "select r from Role r where r.role_id = :id")
    Role getRoleById(int id);

    @Query(value = "select usr from UserDb usr where usr.user_id = :uuid")
    UserDb getUserById(UUID uuid);

    @Query(value = "select status from TransportStatus status where status.status_id = :id")
    TransportStatus getTransportStatusById(int id);

    @Query(value = "select type from TransportType type where type.type_id = :id")
    TransportType getTransportTypeById(int id);

    @Query(value = "select trans from TransportDb trans where trans.transport_id = :id")
    TransportDb getTransportById(int id);
}
