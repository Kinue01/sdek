package com.example.warehousereadservice.warehousereadservice.service;

import com.example.warehousereadservice.warehousereadservice.model.WarehouseType;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseTypeRepository;
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
public class UpdateWarehouseTypeDbService {
    private static final Logger logger = LoggerFactory.getLogger(UpdateWarehouseTypeDbService.class);

    private final KurrentDBClient client;
    private final WarehouseTypeRepository repository;
    private final ObjectMapper mapper;

    public UpdateWarehouseTypeDbService(KurrentDBClient client, WarehouseTypeRepository repository, ObjectMapper mapper) {
        this.client = client;
        this.repository = repository;
        this.mapper = mapper;
    }

    @PostConstruct
    public void init() {
        Publisher<ReadMessage> publisher = client.readStreamReactive("warehouse_type");
        publisher.subscribe(new Subscriber<>() {
            @Override
            public void onSubscribe(Subscription s) {
                logger.info("Subscribed on eventstore");
            }

            @SneakyThrows
            @Override
            public void onNext(ReadMessage readMessage) {
                final RecordedEvent event = readMessage.getEvent().getOriginalEvent();
                switch (event.getEventType()) {
                    case "warehouse_type_add", "warehouse_type_update" -> repository.save(mapper.readValue(event.getEventData(), WarehouseType.class));
                    case "warehouse_type_delete" -> repository.delete(mapper.readValue(event.getEventData(), WarehouseType.class));
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
