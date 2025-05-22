package com.example.deliverypersonellreadservice.deliverypersonellreadservice.service;

import com.eventstore.dbclient.*;
import com.example.deliverypersonellreadservice.deliverypersonellreadservice.model.DeliveryPerson;
import com.example.deliverypersonellreadservice.deliverypersonellreadservice.repository.DeliveryPersonRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.annotation.PostConstruct;
import lombok.SneakyThrows;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class UpdateDeliveryPersonellDbService {
    private static final Logger logger = LoggerFactory.getLogger(UpdateDeliveryPersonellDbService.class);

    private final EventStoreDBClient client;
    private final DeliveryPersonRepository repository;
    private final ObjectMapper objectMapper;

    public UpdateDeliveryPersonellDbService(EventStoreDBClient client, DeliveryPersonRepository repository, ObjectMapper objectMapper) {
        this.client = client;
        this.repository = repository;
        this.objectMapper = objectMapper;
    }

    @PostConstruct
    public void init() {
        final SubscriptionListener listener = new SubscriptionListener() {
            @Override
            @SneakyThrows
            public void onEvent(Subscription subscription, ResolvedEvent event) {
                RecordedEvent ev = event.getOriginalEvent();
                switch (ev.getEventType()) {
                    case "delivery_person_add", "delivery_person_update" -> {
                        DeliveryPerson response = objectMapper.readValue(ev.getEventData(), DeliveryPerson.class);
                        repository.save(response);
                    }
                    case "delivery_person_delete" -> {
                        DeliveryPerson response = objectMapper.readValue(ev.getEventData(), DeliveryPerson.class);
                        repository.delete(response);
                    }
                }

                super.onEvent(subscription, event);
            }

            @Override
            public void onCancelled(Subscription subscription, Throwable exception) {
                if (exception == null) return;
                logger.error(exception.getMessage(), exception);
            }
        };

        client.subscribeToStream("delivery_person", listener);
    }
}
