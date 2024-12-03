package com.example.deliverypersonellreadservice.deliverypersonellreadservice.mapper;

import com.example.deliverypersonellreadservice.deliverypersonellreadservice.model.*;
import com.example.deliverypersonellreadservice.deliverypersonellreadservice.repository.DeliveryPersonRepository;
import jakarta.annotation.PostConstruct;
import org.modelmapper.ModelMapper;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

@Component
@Scope("singleton")
public class DeliveryPersonToDeliveryPersonResponseMapper {
    public static final ModelMapper modelMapper = new ModelMapper();
    private final DeliveryPersonRepository repository;

    public DeliveryPersonToDeliveryPersonResponseMapper(DeliveryPersonRepository repository) {
        this.repository = repository;
    }

    @PostConstruct
    private void init() {
        modelMapper.typeMap(DeliveryPersonResponse.class, DeliveryPerson.class)
                .addMapping(DeliveryPersonResponse::getPerson_id, DeliveryPerson::setPerson_id)
                .addMapping(DeliveryPersonResponse::getPerson_lastname, DeliveryPerson::setPerson_lastname)
                .addMapping(DeliveryPersonResponse::getPerson_firstname, DeliveryPerson::setPerson_firstname)
                .addMapping(DeliveryPersonResponse::getPerson_middlename, DeliveryPerson::setPerson_middlename)
                .addMapping(src -> src.getPerson_user().getUser_id(), DeliveryPerson::setPerson_user_id)
                .addMapping(src -> src.getPerson_transport().getTransport_id(), DeliveryPerson::setPerson_transport_id);
    }

    public DeliveryPersonResponse map(DeliveryPerson deliveryPerson) {
        DeliveryPersonResponse deliveryPersonResponse = new DeliveryPersonResponse();
        UserDb userDb = repository.getUserById(deliveryPerson.getPerson_user_id());
        TransportDb transportDb = repository.getTransportById(deliveryPerson.getPerson_transport_id());

        deliveryPersonResponse.setPerson_id(deliveryPerson.getPerson_id());
        deliveryPersonResponse.setPerson_lastname(deliveryPerson.getPerson_lastname());
        deliveryPersonResponse.setPerson_firstname(deliveryPerson.getPerson_firstname());
        deliveryPersonResponse.setPerson_middlename(deliveryPerson.getPerson_middlename());
        deliveryPersonResponse.setPerson_user(new User(
                userDb.getUser_id(),
                userDb.getUser_login(),
                userDb.getUser_password(),
                userDb.getUser_email(),
                userDb.getUser_phone(),
                userDb.getUser_access_token(),
                repository.getRoleById(userDb.getUser_role_id())
        ));
        deliveryPersonResponse.setPerson_transport(new Transport(
                transportDb.getTransport_id(),
                transportDb.getTransport_name(),
                transportDb.getTransport_reg_number(),
                repository.getTransportTypeById(transportDb.getTransport_type_id()),
                repository.getTransportStatusById(transportDb.getTransport_status_id())
        ));

        return deliveryPersonResponse;
    }
}
