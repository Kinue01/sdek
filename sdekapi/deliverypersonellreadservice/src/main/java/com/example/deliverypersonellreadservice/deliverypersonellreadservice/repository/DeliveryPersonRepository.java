package com.example.deliverypersonellreadservice.deliverypersonellreadservice.repository;

import com.example.deliverypersonellreadservice.deliverypersonellreadservice.model.DeliveryPerson;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DeliveryPersonRepository extends JpaRepository<DeliveryPerson, Integer> {}
