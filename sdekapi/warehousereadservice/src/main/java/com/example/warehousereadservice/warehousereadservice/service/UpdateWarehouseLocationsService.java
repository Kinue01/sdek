package com.example.warehousereadservice.warehousereadservice.service;

import com.example.warehousereadservice.warehousereadservice.model.WarehouseLocation;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseLocationRepository;
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
public class UpdateWarehouseLocationsService {
    private static final Logger logger = LoggerFactory.getLogger(UpdateWarehouseLocationsService.class);

    private final WarehouseLocationRepository warehouseLocationRepository;
    private final KurrentDBClient eventStoreDBClient;
    private final ObjectMapper objectMapper;

    public UpdateWarehouseLocationsService(WarehouseLocationRepository warehouseLocationRepository, KurrentDBClient eventStoreDBClient, ObjectMapper objectMapper) {
        this.warehouseLocationRepository = warehouseLocationRepository;
        this.eventStoreDBClient = eventStoreDBClient;
        this.objectMapper = objectMapper;
    }

    @PostConstruct
    public void init() {
        Publisher<ReadMessage> publisher = eventStoreDBClient.readStreamReactive("warehouseLocation");
        publisher.subscribe(new Subscriber<>() {
            @Override
            public void onSubscribe(Subscription s) {
                logger.info("Subscribed on eventstore");
            }

            @SneakyThrows
            @Override
            public void onNext(ReadMessage readMessage) {
                final RecordedEvent ev = readMessage.getEvent().getOriginalEvent();
                switch (ev.getEventType()) {
                    case "warehouseLocation_add", "warehouseLocation_update" -> warehouseLocationRepository.save(objectMapper.readValue(ev.getEventData(), WarehouseLocation.class));
                    case "warehouseLocation_delete" -> warehouseLocationRepository.delete(objectMapper.readValue(ev.getEventData(), WarehouseLocation.class));
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
