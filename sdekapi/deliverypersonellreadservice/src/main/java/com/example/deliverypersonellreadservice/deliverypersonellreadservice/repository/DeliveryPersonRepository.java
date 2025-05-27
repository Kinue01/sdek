package com.example.deliverypersonellreadservice.deliverypersonellreadservice.repository;

import com.example.deliverypersonellreadservice.deliverypersonellreadservice.model.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface DeliveryPersonRepository extends JpaRepository<DeliveryPerson, Integer> {}
