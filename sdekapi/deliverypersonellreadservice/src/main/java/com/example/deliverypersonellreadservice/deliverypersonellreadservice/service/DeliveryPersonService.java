package com.example.deliverypersonellreadservice.deliverypersonellreadservice.service;

import java.util.List;
import java.util.stream.Collectors;

import com.example.deliverypersonellreadservice.deliverypersonellreadservice.mapper.DeliveryPersonToDeliveryPersonResponseMapper;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import com.example.deliverypersonellreadservice.deliverypersonellreadservice.model.DeliveryPersonResponse;
import com.example.deliverypersonellreadservice.deliverypersonellreadservice.repository.DeliveryPersonRepository;

@Service
public class DeliveryPersonService {
    private final DeliveryPersonRepository repository;
    private final DeliveryPersonToDeliveryPersonResponseMapper mapper;

    public DeliveryPersonService(DeliveryPersonRepository repository, DeliveryPersonToDeliveryPersonResponseMapper mapper) {
        this.repository = repository;
        this.mapper = mapper;
    }

    @Cacheable("deliveryPersonal")
    public List<DeliveryPersonResponse> getPersons() {
        return repository.findAll().parallelStream().map(mapper::mapTo).collect(Collectors.toList());
    }

    @Cacheable("delivery_person")
    public DeliveryPersonResponse getPersonById(int id) {
        var person = repository.findById(id).orElse(null);
        assert person != null;
        return mapper.mapTo(person);
    }
}
