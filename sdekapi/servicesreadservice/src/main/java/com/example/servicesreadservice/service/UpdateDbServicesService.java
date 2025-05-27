package com.example.servicesreadservice.service;

import com.example.servicesreadservice.model.DbService;
import com.example.servicesreadservice.repository.ServiceRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.kurrent.dbclient.*;
import jakarta.annotation.PostConstruct;
import lombok.SneakyThrows;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class UpdateDbServicesService {
    private static final Logger logger = LoggerFactory.getLogger(UpdateDbServicesService.class);

    private final KurrentDBClient eventStoreDBClient;
    private final ServiceRepository dbServiceRepository;
    private final ObjectMapper objectMapper;

    public UpdateDbServicesService(KurrentDBClient eventStoreDBClient, ServiceRepository dbServiceRepository, ObjectMapper objectMapper) {
        this.eventStoreDBClient = eventStoreDBClient;
        this.dbServiceRepository = dbServiceRepository;
        this.objectMapper = objectMapper;
    }

    @PostConstruct
    public void init() {
        SubscribeToStreamOptions options = SubscribeToStreamOptions.get().fromStart().batchSize(1024);
        eventStoreDBClient.subscribeToStream("service", new SubscriptionListener() {
            @Override
            @SneakyThrows
            public void onEvent(io.kurrent.dbclient.Subscription subscription, ResolvedEvent event) {
                final RecordedEvent ev = event.getOriginalEvent();
                switch (ev.getEventType()) {
                    case "service_add", "service_update" -> dbServiceRepository.save(objectMapper.readValue(ev.getEventData(), DbService.class));
                    case "service_delete" -> dbServiceRepository.delete(objectMapper.readValue(ev.getEventData(), DbService.class));
                }
            }

            @Override
            public void onCancelled(io.kurrent.dbclient.Subscription subscription, Throwable exception) {
                logger.error(exception.getMessage(), exception);
            }
        }, options);
    }
}
