import 'package:clientapp/domain/model/Client.dart';
import 'package:clientapp/domain/model/DeliveryPerson.dart';
import 'package:clientapp/domain/model/Package.dart';
import 'package:clientapp/domain/model/PackageStatus.dart';
import 'package:clientapp/domain/model/PackageType.dart';
import 'package:clientapp/domain/model/Warehouse.dart';
import 'package:clientapp/domain/usecase/client/GetClientsUseCase.dart';
import 'package:clientapp/domain/usecase/delivery_person/get_delivery_personal_use_case.dart';
import 'package:clientapp/domain/usecase/pack/GetPackagesUseCase.dart';
import 'package:clientapp/domain/usecase/package_status/GetPackageStatusesUseCase.dart';
import 'package:clientapp/domain/usecase/package_type/GetPackageTypesUseCase.dart';
import 'package:clientapp/domain/usecase/warehouse/get_warehouses_use_case.dart';
import 'package:flutter/cupertino.dart';

class PackagesPageController {
  late List<Package> packages = [];
  late List<Client> clients = [];
  late List<Warehouse> warehouses = [];
  late List<PackageType> packTypes = [];
  late List<PackageStatus> packStatuses = [];
  late List<DeliveryPerson> delivery = [];

  final filteredPackages = ValueNotifier(<Package>[]);

  final GetPackagesUseCase getPackagesUseCase;
  final GetPackageStatusesUseCase getPackageStatusesUseCase;
  final GetPackageTypesUseCase getPackageTypesUseCase;
  final GetClientsUseCase getClientsUseCase;
  final GetDeliveryPersonalUseCase getDeliveryPersonalUseCase;
  final GetWarehousesUseCase getWarehousesUseCase;

  PackagesPageController({
    required this.getPackagesUseCase,
    required this.getWarehousesUseCase,
    required this.getDeliveryPersonalUseCase,
    required this.getClientsUseCase,
    required this.getPackageTypesUseCase,
    required this.getPackageStatusesUseCase
  });

  Future<void> init() async {
    packages = await getPackagesUseCase.exec();
    filteredPackages.value = packages;

    packStatuses = await getPackageStatusesUseCase.exec();
    packTypes = await getPackageTypesUseCase.exec();
    warehouses = await getWarehousesUseCase.exec();
    delivery = await getDeliveryPersonalUseCase.exec();
    clients = await getClientsUseCase.exec();
  }
}