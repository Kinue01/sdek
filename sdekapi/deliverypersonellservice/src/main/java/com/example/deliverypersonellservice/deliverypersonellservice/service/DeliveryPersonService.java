package com.example.deliverypersonellservice.deliverypersonellservice.service;

import com.example.deliverypersonellservice.deliverypersonellservice.model.DeliveryPerson;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.kurrent.dbclient.EventData;
import io.kurrent.dbclient.KurrentDBClient;
import lombok.SneakyThrows;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class DeliveryPersonService {
    private final KurrentDBClient client;
    private final ObjectMapper mapper;

    public DeliveryPersonService(KurrentDBClient client, ObjectMapper mapper) {
        this.client = client;
        this.mapper = mapper;
    }

    @SneakyThrows
    public DeliveryPerson addPerson(DeliveryPerson person) {
        final EventData data = EventData.builderAsJson("delivery_person_add", mapper.writeValueAsBytes(person)).build();
        client.appendToStream("delivery_person", data).join();
        return person;
    }

    @SneakyThrows
    public DeliveryPerson updatePerson(DeliveryPerson person) {
        final EventData data = EventData.builderAsJson("delivery_person_update", mapper.writeValueAsBytes(person)).build();
        client.appendToStream("delivery_person", data).join();
        return person;
    }

    @SneakyThrows
    public DeliveryPerson deletePerson(DeliveryPerson person) {
        final EventData data = EventData.builderAsJson("delivery_person_delete", mapper.writeValueAsBytes(person)).build();
        client.appendToStream("delivery_person", data).join();
        return person;
    }
}
