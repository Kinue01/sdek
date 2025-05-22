package com.example.servicesreadservice.repository;

import com.example.servicesreadservice.model.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface PackageServiceRepository extends JpaRepository<PackageServices, UUID> {
    @Query(value = "select p from DbPackage p where p.package_uuid = :id")
    Optional<DbPackage> getPackageById(UUID id);

    @Query(value = "select dp from DbDeliveryPerson dp where dp.person_id = :id")
    Optional<DbDeliveryPerson> getDeliveryPersonById(int id);

    @Query(value = "select u from DbUser u where u.user_id = :id")
    Optional<DbUser> getUserById(UUID id);

    @Query(value = "select r from Role r where r.role_id = :id")
    Optional<Role> getRoleById(short id);

    @Query(value = "select t from DbTransport t where t.transport_id = :id")
    Optional<DbTransport> getTransportById(int id);

    @Query(value = "select s from TransportStatus s where s.status_id = :id")
    Optional<TransportStatus> getTransportStatusById(short id);

    @Query(value = "select t from TransportType t where t.type_id = :id")
    Optional<TransportType> getTransportTypeById(short id);

    @Query(value = "select t from PackageType t where t.type_id = :id")
    Optional<PackageType> getPackageTypeById(short id);

    @Query("select s from PackageStatus s where s.status_id = :id")
    Optional<PackageStatus> getPackageStatusById(short id);

    @Query("select c from DbClient c where c.client_id = :id")
    Optional<DbClient> getClientById(int id);

    @Query("select w from DbWarehouse w where w.warehouse_id = :id")
    Optional<DbWarehouse> getWarehouseById(int id);

    @Query("select t from WarehouseType t where t.type_id = :id")
    Optional<WarehouseType> getWarehouseTypeById(short id);

    @Query("select p from PackagePaytype p where p.type_id = :id")
    Optional<PackagePaytype> getPackagePaytypeById(short id);

    @Query("select i from PackageItem i where i.item_id = :id")
    PackageItem getPackageItemsById(int id);

    @Query("select pi.item_id from PackageItems pi where pi.package_id = :id")
    List<Integer> getPackageItemsIdById(UUID id);
}
