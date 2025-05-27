package com.example.warehousereadservice.warehousereadservice.service;

import com.example.warehousereadservice.warehousereadservice.model.WarehouseResponse;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseRepository;
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
public class UpdateWarehouseDbService {
    private static final Logger logger = LoggerFactory.getLogger(UpdateWarehouseDbService.class);

    private final KurrentDBClient client;
    private final WarehouseRepository repository;
    private final ObjectMapper objectMapper;

    public UpdateWarehouseDbService(KurrentDBClient client, WarehouseRepository repository, ObjectMapper objectMapper) {
        this.client = client;
        this.repository = repository;
        this.objectMapper = objectMapper;
    }

    @PostConstruct
    public void init() {
        Publisher<ReadMessage> publisher = client.readStreamReactive("warehouse");
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
                    case "warehouse_add", "warehouse_update" -> repository.save(objectMapper.readValue(ev.getEventData(), WarehouseResponse.class));
                    case "warehouse_delete" -> repository.delete(objectMapper.readValue(ev.getEventData(), WarehouseResponse.class));
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
