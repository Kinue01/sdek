package com.example.warehousereadservice.warehousereadservice;

import com.eventstore.dbclient.EventStoreDBClient;
import com.eventstore.dbclient.EventStoreDBClientSettings;
import com.eventstore.dbclient.EventStoreDBConnectionString;
import com.example.warehousereadservice.warehousereadservice.model.WarehouseResponse;
import com.example.warehousereadservice.warehousereadservice.repository.WarehouseTypeRepository;
import org.modelmapper.ModelMapper;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.cache.RedisCacheConfiguration;
import org.springframework.data.redis.serializer.GenericJackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.RedisSerializationContext;
import org.springframework.data.redis.serializer.StringRedisSerializer;
import org.springframework.scheduling.annotation.EnableAsync;

import java.time.Duration;

@Configuration
@EnableAsync
@EnableCaching
public class AppConf {
    @Bean
    public EventStoreDBClient eventStoreDBClient() {
        final EventStoreDBClientSettings settings = EventStoreDBConnectionString.parseOrThrow("esdb://admin:@eventstore:2113?tls=false");
//        final EventStoreDBClientSettings settings = EventStoreDBConnectionString.parseOrThrow("esdb://admin:@localhost:2113?tls=false");
        return EventStoreDBClient.create(settings);
    }

//    @Bean
//    public ModelMapper modelMapper() {
//        ModelMapper mapper = new ModelMapper();
//        mapper.typeMap(WarehouseResponse.class, Warehouse.class)
//                .addMapping(WarehouseResponse::getWarehouse_id, Warehouse::setWarehouse_id)
//                .addMapping(WarehouseResponse::getWarehouse_name, Warehouse::setWarehouse_name)
//                .addMapping(WarehouseResponse::getWarehouse_address, Warehouse::setWarehouse_address)
//                .addMapping(src -> src.getWarehouse_type().getType_id(), Warehouse::setWarehouse_type_id);
//        return mapper;
//    }

    @Bean
    public RedisCacheConfiguration cacheConfiguration() {
        return RedisCacheConfiguration.defaultCacheConfig()
                .entryTtl(Duration.ofMinutes(60))
                .disableCachingNullValues()
                .serializeKeysWith(RedisSerializationContext.SerializationPair.fromSerializer(new StringRedisSerializer()))
                .serializeValuesWith(RedisSerializationContext.SerializationPair.fromSerializer(new GenericJackson2JsonRedisSerializer()));
    }
}
