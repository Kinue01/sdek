package com.example.deliverypersonellreadservice.deliverypersonellreadservice.service;

import com.eventstore.dbclient.*;
import com.example.deliverypersonellreadservice.deliverypersonellreadservice.mapper.DeliveryPersonToDeliveryPersonResponseMapper;
import com.example.deliverypersonellreadservice.deliverypersonellreadservice.model.DeliveryPerson;
import com.example.deliverypersonellreadservice.deliverypersonellreadservice.model.DeliveryPersonResponse;
import com.example.deliverypersonellreadservice.deliverypersonellreadservice.repository.DeliveryPersonRepository;
import jakarta.annotation.PostConstruct;
import org.apache.commons.lang3.SerializationUtils;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

@Service
public class UpdateDeliveryPersonellDbService {
    private final EventStoreDBClient client;
    private final DeliveryPersonRepository repository;

    public UpdateDeliveryPersonellDbService(EventStoreDBClient client, DeliveryPersonRepository repository) {
        this.client = client;
        this.repository = repository;
    }

    @PostConstruct
    public void init() {
        final SubscriptionListener listener = new SubscriptionListener() {
            @Override
            public void onEvent(Subscription subscription, ResolvedEvent event) {
                RecordedEvent ev = event.getOriginalEvent();
                switch (ev.getEventType()) {
                    case "delivery_person_add", "delivery_person_update" -> {
                        DeliveryPersonResponse response = SerializationUtils.deserialize(ev.getEventData());
                        repository.save(DeliveryPersonToDeliveryPersonResponseMapper.modelMapper.map(response, DeliveryPerson.class));
                    }
                    case "delivery_person_delete" -> {
                        DeliveryPersonResponse response = SerializationUtils.deserialize(ev.getEventData());
                        repository.delete(DeliveryPersonToDeliveryPersonResponseMapper.modelMapper.map(response, DeliveryPerson.class));
                    }
                }
                super.onEvent(subscription, event);
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
