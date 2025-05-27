package com.example.deliverypersonellreadservice.deliverypersonellreadservice.service;

import com.example.deliverypersonellreadservice.deliverypersonellreadservice.model.DeliveryPerson;
import com.example.deliverypersonellreadservice.deliverypersonellreadservice.repository.DeliveryPersonRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.kurrent.dbclient.KurrentDBClient;
import io.kurrent.dbclient.ReadMessage;
import io.kurrent.dbclient.ReadStreamOptions;
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
public class UpdateDeliveryPersonellDbService {
    private static final Logger logger = LoggerFactory.getLogger(UpdateDeliveryPersonellDbService.class);

    private final KurrentDBClient client;
    private final DeliveryPersonRepository repository;
    private final ObjectMapper objectMapper;

    public UpdateDeliveryPersonellDbService(KurrentDBClient client, DeliveryPersonRepository repository, ObjectMapper objectMapper) {
        this.client = client;
        this.repository = repository;
        this.objectMapper = objectMapper;
    }

    @PostConstruct
    public void init() {
        ReadStreamOptions options = ReadStreamOptions.get().forwards().fromStart();
        Publisher<ReadMessage> publisher = client.readStreamReactive("delivery_person", options);
        publisher.subscribe(new Subscriber<>() {
            @Override
            public void onSubscribe(Subscription s) {
                logger.info("Subscribed to event stream");
            }

            @SneakyThrows
            @Override
            public void onNext(ReadMessage readMessage) {
                RecordedEvent ev = readMessage.getEvent().getOriginalEvent();
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
