package com.example.deliverypersonellreadservice.deliverypersonellreadservice.service;

import com.example.deliverypersonellreadservice.deliverypersonellreadservice.model.DeliveryPerson;
import com.example.deliverypersonellreadservice.deliverypersonellreadservice.repository.DeliveryPersonRepository;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DeliveryPersonService {
    private final DeliveryPersonRepository repository;

    public DeliveryPersonService(DeliveryPersonRepository repository) {
        this.repository = repository;
    }

    public List<DeliveryPerson> getPersons() {
        return repository.findAll();
    }

    public DeliveryPerson getPersonById(int id) {
        var person = repository.findById(id).orElse(null);
        assert person != null;
        return person;
    }
}
