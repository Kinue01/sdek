package com.example.servicesreadservice.service;

import com.eventstore.dbclient.*;
import com.example.servicesreadservice.mapper.PackageServicesToResponseMapper;
import com.example.servicesreadservice.model.PackageServiceResponse;
import com.example.servicesreadservice.repository.PackageServiceRepository;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.annotation.PostConstruct;
import lombok.SneakyThrows;
import org.springframework.stereotype.Service;

@Service
public class UpdatePackageServicesService {
    private final EventStoreDBClient eventStoreDBClient;
    private final PackageServiceRepository packageServiceRepository;
    private final ObjectMapper objectMapper;
    private final PackageServicesToResponseMapper packageServicesToResponseMapper;

    public UpdatePackageServicesService(EventStoreDBClient eventStoreDBClient, PackageServiceRepository packageServiceRepository, ObjectMapper objectMapper, PackageServicesToResponseMapper packageServicesToResponseMapper) {
        this.eventStoreDBClient = eventStoreDBClient;
        this.packageServiceRepository = packageServiceRepository;
        this.objectMapper = objectMapper;
        this.packageServicesToResponseMapper = packageServicesToResponseMapper;
    }

    @PostConstruct
    public void init() {
        final SubscriptionListener listener = new SubscriptionListener() {
            @Override
            @SneakyThrows
            public void onEvent(Subscription subscription, ResolvedEvent event) {
                RecordedEvent ev = event.getOriginalEvent();
                switch (ev.getEventType()) {
                    case "package_services_add", "package_services_update" -> {
                        PackageServiceResponse response = objectMapper.readValue(ev.getEventData(), PackageServiceResponse.class);
                        packageServiceRepository.save(packageServicesToResponseMapper.mapTo(response));
                    }
                    case "package_services_delete" -> {
                        PackageServiceResponse input = objectMapper.readValue(ev.getEventData(), PackageServiceResponse.class);
                        packageServiceRepository.delete(packageServicesToResponseMapper.mapTo(input));
                    }
                }
                super.onEvent(subscription, event);
            }

            @Override
            public void onCancelled(Subscription subscription, Throwable exception) {
                if (exception == null) return;
                super.onCancelled(subscription, exception);
            }
        };

        eventStoreDBClient.subscribeToStream("package_services", listener);
    }
}
