package com.example.servicesreadservice.service;

import com.eventstore.dbclient.*;
import com.example.servicesreadservice.repository.ServiceRepository;
import jakarta.annotation.PostConstruct;
import org.apache.commons.lang3.SerializationUtils;
import org.springframework.stereotype.Service;

@Service
public class UpdateDbServicesService {
    private final EventStoreDBClient eventStoreDBClient;
    private final ServiceRepository dbServiceRepository;

    public UpdateDbServicesService(EventStoreDBClient eventStoreDBClient, ServiceRepository dbServiceRepository) {
        this.eventStoreDBClient = eventStoreDBClient;
        this.dbServiceRepository = dbServiceRepository;
    }

    @PostConstruct
    public void init() {
        final SubscriptionListener listener = new SubscriptionListener() {
            @Override
            public void onEvent(Subscription subscription, ResolvedEvent event) {
                final RecordedEvent ev = event.getOriginalEvent();
                switch (ev.getEventType()) {
                    case "service_add", "service_update" -> dbServiceRepository.save(SerializationUtils.deserialize(ev.getEventData()));
                    case "service_delete" -> dbServiceRepository.delete(SerializationUtils.deserialize(ev.getEventData()));
                }
                super.onEvent(subscription, event);
            }

            @Override
            public void onCancelled(Subscription subscription, Throwable exception) {
                if (exception == null) return;
                super.onCancelled(subscription, exception);
            }
        };

        eventStoreDBClient.subscribeToStream("service", listener);
    }
}
