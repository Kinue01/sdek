package com.example.deliverypersonellreadservice.deliverypersonellreadservice.service;

import com.eventstore.dbclient.*;
import com.example.deliverypersonellreadservice.deliverypersonellreadservice.mapper.DeliveryPersonToDeliveryPersonResponseMapper;
import com.example.deliverypersonellreadservice.deliverypersonellreadservice.model.DeliveryPerson;
import com.example.deliverypersonellreadservice.deliverypersonellreadservice.model.DeliveryPersonResponse;
import com.example.deliverypersonellreadservice.deliverypersonellreadservice.repository.DeliveryPersonRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.annotation.PostConstruct;
import lombok.SneakyThrows;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.io.IOException;

@Service
public class UpdateDeliveryPersonellDbService {
    private final Logger logger = LoggerFactory.getLogger(UpdateDeliveryPersonellDbService.class);

    private final EventStoreDBClient client;
    private final DeliveryPersonRepository repository;
    private final ObjectMapper objectMapper;
    private final DeliveryPersonToDeliveryPersonResponseMapper deliveryPersonToDeliveryPersonResponseMapper;

    public UpdateDeliveryPersonellDbService(EventStoreDBClient client, DeliveryPersonRepository repository, ObjectMapper objectMapper, DeliveryPersonToDeliveryPersonResponseMapper deliveryPersonToDeliveryPersonResponseMapper) {
        this.client = client;
        this.repository = repository;
        this.objectMapper = objectMapper;
        this.deliveryPersonToDeliveryPersonResponseMapper = deliveryPersonToDeliveryPersonResponseMapper;
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
                        DeliveryPersonResponse response = objectMapper.readValue(ev.getEventData(), DeliveryPersonResponse.class);
                        repository.save(deliveryPersonToDeliveryPersonResponseMapper.mapFrom(response));
                    }
                    case "delivery_person_delete" -> {
                        DeliveryPersonResponse response = objectMapper.readValue(ev.getEventData(), DeliveryPersonResponse.class);
                        repository.delete(deliveryPersonToDeliveryPersonResponseMapper.mapFrom(response));
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
