package com.example.servicesreadservice.mapper;

import com.example.servicesreadservice.model.*;
import com.example.servicesreadservice.model.Package;
import com.example.servicesreadservice.repository.PackageServiceRepository;
import com.example.servicesreadservice.repository.ServiceRepository;
import jakarta.annotation.PostConstruct;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Component;

@Component
public class PackageServicesToResponseMapper {
    private final ModelMapper modelMapper = new ModelMapper();
    private final PackageServiceRepository packageServiceRepository;
    private final ServiceRepository serviceRepository;

    public PackageServicesToResponseMapper(PackageServiceRepository packageServiceRepository, ServiceRepository serviceRepository) {
        this.packageServiceRepository = packageServiceRepository;
        this.serviceRepository = serviceRepository;
    }

    @PostConstruct
    private void init() {
        modelMapper.typeMap(PackageServiceResponse.class, PackageServices.class)
                .addMapping(src -> src.getDb_package().getPackage_uuid(), PackageServices::setPackage_id)
                .addMapping(src -> src.getService().getService_id(), PackageServices::setService_id)
                .addMapping(PackageServiceResponse::getService_count, PackageServices::setService_count);
    }

    public PackageServices mapTo(PackageServiceResponse src) {
        return modelMapper.map(src, PackageServices.class);
    }

    public PackageServiceResponse mapFrom(PackageServices src) {
        final PackageServiceResponse res = new PackageServiceResponse();
        final DbPackage dbPackage = packageServiceRepository.getPackageById(src.getPackage_id()).orElse(null);
        final DbDeliveryPerson deliveryPerson = packageServiceRepository.getDeliveryPersonById(src.getService_id()).orElse(null);
        final DbUser user = packageServiceRepository.getUserById(deliveryPerson.getPerson_user_id()).orElse(null);
        final DbTransport transport = packageServiceRepository.getTransportById(deliveryPerson.getPerson_transport_id()).orElse(null);
        final DbClient sender = packageServiceRepository.getClientById(dbPackage.getPackage_sender_id()).orElse(null);
        final DbClient receiver = packageServiceRepository.getClientById(dbPackage.getPackage_receiver_id()).orElse(null);
        final DbUser senderUser = packageServiceRepository.getUserById(sender.getClient_user_id()).orElse(null);
        final DbUser receiverUser = packageServiceRepository.getUserById(receiver.getClient_user_id()).orElse(null);
        final DbWarehouse warehouse = packageServiceRepository.getWarehouseById(dbPackage.getPackage_warehouse_id()).orElse(null);

        DbClient payer;
        DbUser payerUser;

        if (sender.getClient_id() == dbPackage.getPackage_payer_id()) {
            payer = sender;
            payerUser = senderUser;
        }
        else {
            payer = receiver;
            payerUser = receiverUser;
        }

        res.setDb_package(new Package(
                dbPackage.getPackage_uuid(),
                dbPackage.getPackage_send_date(),
                dbPackage.getPackage_receive_date(),
                dbPackage.getPackage_weight(),
                new DeliveryPerson(
                        deliveryPerson.getPerson_id(),
                        deliveryPerson.getPerson_lastname(),
                        deliveryPerson.getPerson_firstname(),
                        deliveryPerson.getPerson_middlename(),
                        new User(
                                user.getUser_id(),
                                user.getUser_login(),
                                user.getUser_password(),
                                user.getUser_email(),
                                user.getUser_phone(),
                                user.getUser_access_token(),
                                packageServiceRepository.getRoleById(user.getUser_role_id()).orElse(null)
                        ),
                        new Transport(
                                transport.getTransport_id(),
                                transport.getTransport_name(),
                                transport.getTransport_reg_number(),
                                packageServiceRepository.getTransportTypeById(transport.getTransport_type_id()).orElse(null),
                                packageServiceRepository.getTransportStatusById(transport.getTransport_status_id()).orElse(null)
                        )
                ),
                packageServiceRepository.getPackageTypeById(dbPackage.getPackage_type_id()).orElse(null),
                packageServiceRepository.getPackageStatusById(dbPackage.getPackage_status_id()).orElse(null),
                new Client(
                        sender.getClient_id(),
                        sender.getClient_lastname(),
                        sender.getClient_firstname(),
                        sender.getClient_middlename(),
                        new User(
                                senderUser.getUser_id(),
                                senderUser.getUser_login(),
                                senderUser.getUser_password(),
                                senderUser.getUser_email(),
                                senderUser.getUser_phone(),
                                senderUser.getUser_access_token(),
                                packageServiceRepository.getRoleById(senderUser.getUser_role_id()).orElse(null)
                        )
                ),
                new Client(
                        receiver.getClient_id(),
                        receiver.getClient_lastname(),
                        receiver.getClient_firstname(),
                        receiver.getClient_middlename(),
                        new User(
                                receiverUser.getUser_id(),
                                receiverUser.getUser_login(),
                                receiverUser.getUser_password(),
                                receiverUser.getUser_email(),
                                receiverUser.getUser_phone(),
                                receiverUser.getUser_access_token(),
                                packageServiceRepository.getRoleById(receiverUser.getUser_role_id()).orElse(null)
                        )
                ),
                new Warehouse(
                        warehouse.getWarehouse_id(),
                        warehouse.getWarehouse_name(),
                        warehouse.getWarehouse_address(),
                        packageServiceRepository.getWarehouseTypeById(warehouse.getWarehouse_type_id()).orElse(null)
                ),
                packageServiceRepository.getPackagePaytypeById(dbPackage.getPackage_paytype_id()).orElse(null),
                new Client(
                        payer.getClient_id(),
                        payer.getClient_lastname(),
                        payer.getClient_firstname(),
                        payer.getClient_middlename(),
                        new User(
                                payerUser.getUser_id(),
                                payerUser.getUser_login(),
                                payerUser.getUser_password(),
                                payerUser.getUser_email(),
                                payerUser.getUser_phone(),
                                payerUser.getUser_access_token(),
                                packageServiceRepository.getRoleById(payerUser.getUser_role_id()).orElse(null)
                        )
                ),
                packageServiceRepository.getPackageItemsIdById(dbPackage.getPackage_uuid()).parallelStream().map(packageServiceRepository::getPackageItemsById).toList()
        ));
        res.setService(serviceRepository.findById(src.getService_id()).orElse(null));
        res.setService_count(src.getService_count());
        return res;
    }
}
