package com.example.deliverypersonellservice.deliverypersonellservice.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.SneakyThrows;
import org.springframework.stereotype.Service;
import com.eventstore.dbclient.EventData;
import com.eventstore.dbclient.EventStoreDBClient;
import com.example.deliverypersonellservice.deliverypersonellservice.model.DeliveryPerson;

@Service
public class DeliveryPersonService {
    private final EventStoreDBClient client;
    private final ObjectMapper mapper;

    public DeliveryPersonService(EventStoreDBClient client, ObjectMapper mapper) {
        this.client = client;
        this.mapper = mapper;
    }

    @SneakyThrows
    public DeliveryPerson addPerson(DeliveryPerson person) {
        final EventData data = EventData.builderAsBinary("delivery_person_add", mapper.writeValueAsBytes(person)).build();
        client.appendToStream("delivery_person", data).join();
        return person;
    }

    @SneakyThrows
    public DeliveryPerson updatePerson(DeliveryPerson person) {
        final EventData data = EventData.builderAsBinary("delivery_person_update", mapper.writeValueAsBytes(person)).build();
        client.appendToStream("delivery_person", data).join();
        return person;
    }

    @SneakyThrows
    public DeliveryPerson deletePerson(DeliveryPerson person) {
        final EventData data = EventData.builderAsBinary("delivery_person_delete", mapper.writeValueAsBytes(person)).build();
        client.appendToStream("delivery_person", data).join();
        return person;
    }
}
