package com.example.servicesreadservice.service;

import com.example.servicesreadservice.model.DbService;
import com.example.servicesreadservice.repository.ServiceRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.kurrent.dbclient.KurrentDBClient;
import io.kurrent.dbclient.ReadMessage;
import io.kurrent.dbclient.RecordedEvent;
import jakarta.annotation.PostConstruct;
import lombok.SneakyThrows;
import org.reactivestreams.Publisher;
import org.reactivestreams.Subscriber;
import org.reactivestreams.Subscription;
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
        Publisher<ReadMessage> publisher = eventStoreDBClient.readStreamReactive("service");
        publisher.subscribe(new Subscriber<>() {
            @Override
            public void onSubscribe(Subscription s) {
                logger.info("Subscribed to eventstore");
            }

            @SneakyThrows
            @Override
            public void onNext(ReadMessage readMessage) {
                final RecordedEvent ev = readMessage.getEvent().getOriginalEvent();
                switch (ev.getEventType()) {
                    case "service_add", "service_update" -> dbServiceRepository.save(objectMapper.readValue(ev.getEventData(), DbService.class));
                    case "service_delete" -> dbServiceRepository.delete(objectMapper.readValue(ev.getEventData(), DbService.class));
                }
            }

            @Override
            public void onError(Throwable t) {
                logger.error(t.getMessage(), t);
            }

            @Override
            public void onComplete() {}
        });
    }
}
