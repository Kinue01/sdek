package com.example.servicesreadservice.service;

import com.example.servicesreadservice.model.DbPackage;
import com.example.servicesreadservice.model.PackageServiceResponse;
import com.example.servicesreadservice.repository.PackageRepository;
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
public class UpdatePackageServicesService {
    private static final Logger logger = LoggerFactory.getLogger(UpdatePackageServicesService.class);

    private final KurrentDBClient eventStoreDBClient;
    private final PackageRepository packageRepository;
    private final ServiceRepository serviceRepository;
    private final ObjectMapper objectMapper;

    public UpdatePackageServicesService(KurrentDBClient eventStoreDBClient, ObjectMapper objectMapper, ServiceRepository serviceRepository, PackageRepository packageRepository) {
        this.eventStoreDBClient = eventStoreDBClient;
        this.objectMapper = objectMapper;
        this.serviceRepository = serviceRepository;
        this.packageRepository = packageRepository;
    }

    @PostConstruct
    public void init() {
        Publisher<ReadMessage> publisher = eventStoreDBClient.readStreamReactive("package_services");
        publisher.subscribe(new Subscriber<>() {
            @Override
            public void onSubscribe(Subscription s) {
                logger.info("Subscribed to eventstore");
            }

            @SneakyThrows
            @Override
            public void onNext(ReadMessage readMessage) {
                RecordedEvent ev = readMessage.getEvent().getOriginalEvent();
                switch (ev.getEventType()) {
                    case "package_services_add", "package_services_update" -> {
                        PackageServiceResponse response = objectMapper.readValue(ev.getEventData(), PackageServiceResponse.class);

                        serviceRepository.save(response.getService()); // save service

                        DbPackage dbPackage = packageRepository.findById(response.getDb_package().getPackage_uuid()).orElse(null);
                        assert dbPackage != null;
                        dbPackage.getPackage_services().add(response.getService());
                        packageRepository.save(dbPackage); // save package with new/updated service
                    }
                    case "package_services_delete" -> {
                        PackageServiceResponse input = objectMapper.readValue(ev.getEventData(), PackageServiceResponse.class);

                        serviceRepository.delete(input.getService());

                        DbPackage dbPackage = packageRepository.findById(input.getDb_package().getPackage_uuid()).orElse(null);
                        assert dbPackage != null;
                        dbPackage.getPackage_services().remove(input.getService());
                        packageRepository.save(dbPackage);
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
