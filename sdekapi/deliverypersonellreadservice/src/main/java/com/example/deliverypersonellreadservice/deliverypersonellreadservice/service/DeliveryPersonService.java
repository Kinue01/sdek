package com.example.deliverypersonellreadservice.deliverypersonellreadservice.service;

import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;

import com.example.deliverypersonellreadservice.deliverypersonellreadservice.mapper.DeliveryPersonToDeliveryPersonResponseMapper;
import com.example.deliverypersonellreadservice.deliverypersonellreadservice.model.DeliveryPerson;
import org.modelmapper.ModelMapper;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.scheduling.annotation.Async;
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

    @Async
    @Cacheable("deliveryPersonal")
    public CompletableFuture<List<DeliveryPersonResponse>> getPersons() {
        return CompletableFuture.completedFuture(
                repository.findAll().parallelStream().map(mapper::map).collect(Collectors.toList())
        );
    }

    @Async
    @Cacheable("delivery_person")
    public CompletableFuture<DeliveryPersonResponse> getPersonById(int id) {
        var person = repository.findById(id).orElse(null);
        assert person != null;
        return CompletableFuture.completedFuture(mapper.map(person));
    }
}
