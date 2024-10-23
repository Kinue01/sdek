package com.example.deliverypersonellservice.deliverypersonellservice.service;

import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import com.eventstore.dbclient.EventData;
import com.eventstore.dbclient.EventStoreDBClient;
import com.example.deliverypersonellservice.deliverypersonellservice.model.DeliveryPerson;

@Service
public class DeliveryPersonService {
    EventStoreDBClient client;

    public DeliveryPersonService(EventStoreDBClient client) {
        this.client = client;
    }

    @Async
    public CompletableFuture<DeliveryPerson> addPerson(DeliveryPerson person) {
        EventData data = EventData.builderAsJson("delivery_person_add", person).build();
        try {
            client.appendToStream("delivery_person", data).get();
            return CompletableFuture.completedFuture(person);
        } catch (ExecutionException | InterruptedException e) {
            System.out.println("err");
            return CompletableFuture.completedFuture(null);
        }
    } 

    @Async
    public CompletableFuture<DeliveryPerson> updatePerson(DeliveryPerson person) {
        EventData data = EventData.builderAsJson("delivery_person_update", person).build();
        try {
            client.appendToStream("delivery_person", data).get();
            return CompletableFuture.completedFuture(person);
        } catch (ExecutionException | InterruptedException e) {
            System.out.println("err");
            return CompletableFuture.completedFuture(null);
        }
    }

    @Async
    public CompletableFuture<DeliveryPerson> deletePerson(DeliveryPerson person) {
        EventData data = EventData.builderAsJson("delivery_person_delete", person).build();
        try {
            client.appendToStream("delivery_person", data).get();
            return CompletableFuture.completedFuture(person);
        } catch (ExecutionException | InterruptedException e) {
            System.out.println("err");
            return CompletableFuture.completedFuture(null);
        }
    }
}
