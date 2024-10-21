package com.example.deliverypersonellservice.deliverypersonellservice;

import com.eventstore.dbclient.EventStoreDBClient;
import com.eventstore.dbclient.EventStoreDBClientSettings;
import com.eventstore.dbclient.EventStoreDBConnectionString;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class AppConf {
    @Bean
    public EventStoreDBClient eventStoreDBClient() {
        EventStoreDBClientSettings settings = EventStoreDBConnectionString.parseOrThrow("esdb://admin:@localhost:2113");
        return EventStoreDBClient.create(settings);
    }
}
