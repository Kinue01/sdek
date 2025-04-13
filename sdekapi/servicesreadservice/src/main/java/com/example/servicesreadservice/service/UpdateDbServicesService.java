package com.example.servicesreadservice.service;

import com.eventstore.dbclient.*;
import com.example.servicesreadservice.model.DbService;
import com.example.servicesreadservice.repository.ServiceRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.annotation.PostConstruct;
import lombok.SneakyThrows;
import org.springframework.stereotype.Service;

@Service
public class UpdateDbServicesService {
    private final EventStoreDBClient eventStoreDBClient;
    private final ServiceRepository dbServiceRepository;
    private final ObjectMapper objectMapper;

    public UpdateDbServicesService(EventStoreDBClient eventStoreDBClient, ServiceRepository dbServiceRepository, ObjectMapper objectMapper) {
        this.eventStoreDBClient = eventStoreDBClient;
        this.dbServiceRepository = dbServiceRepository;
        this.objectMapper = objectMapper;
    }

    @PostConstruct
    public void init() {
        final SubscriptionListener listener = new SubscriptionListener() {
            @Override
            @SneakyThrows
            public void onEvent(Subscription subscription, ResolvedEvent event) {
                final RecordedEvent ev = event.getOriginalEvent();
                switch (ev.getEventType()) {
                    case "service_add", "service_update" -> dbServiceRepository.save(objectMapper.readValue(ev.getEventData(), DbService.class));
                    case "service_delete" -> dbServiceRepository.delete(objectMapper.readValue(ev.getEventData(), DbService.class));
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
