package com.example.deliverypersonellreadservice.deliverypersonellreadservice.repository;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import com.example.deliverypersonellreadservice.deliverypersonellreadservice.model.DeliveryPerson;

@Repository
public interface DeliveryPersonRepository extends CrudRepository<DeliveryPerson, Integer> {
    
}
