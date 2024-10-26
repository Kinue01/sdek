package com.example.deliverypersonellreadservice.deliverypersonellreadservice.service;

import com.eventstore.dbclient.*;
import com.example.deliverypersonellreadservice.deliverypersonellreadservice.model.DeliveryPerson;
import com.example.deliverypersonellreadservice.deliverypersonellreadservice.repository.DeliveryPersonRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Service;

import java.io.IOException;

@Service
public class UpdateDeliveryPersonellDbService {
    final EventStoreDBClient client;
    final DeliveryPersonRepository repository;

    public UpdateDeliveryPersonellDbService(EventStoreDBClient client, DeliveryPersonRepository repository) {
        this.client = client;
        this.repository = repository;
    }

    public void init() {
        SubscriptionListener listener = new SubscriptionListener() {
            @Override
            public void onEvent(Subscription subscription, ResolvedEvent event) {
                RecordedEvent ev = event.getOriginalEvent();
                switch (ev.getEventType()) {
                    case "delivery_person_add", "delivery_person_update" -> {
                        try {
                            repository.save(new ObjectMapper().readValue(ev.getEventData(), DeliveryPerson.class));
                        } catch (IOException e) {
                            throw new RuntimeException(e);
                        }
                    }
                    case "delivery_person_delete" -> {
                        try {
                            repository.delete(new ObjectMapper().readValue(ev.getEventData(), DeliveryPerson.class));
                        } catch (IOException e) {
                            throw new RuntimeException(e);
                        }
                    }
                }
            }

            @Override
            public void onCancelled(Subscription subscription, Throwable exception) {
                if (exception == null)
                    return;
                super.onCancelled(subscription, exception);
            }
        };
        client.subscribeToStream("delivery_person", listener);
    }
}
