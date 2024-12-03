import 'package:clientapp/domain/model/Client.dart';
import 'package:clientapp/domain/model/DeliveryPerson.dart';
import 'package:clientapp/domain/model/Package.dart';
import 'package:clientapp/domain/model/PackageItem.dart';
import 'package:clientapp/domain/model/PackagePaytype.dart';
import 'package:clientapp/domain/model/PackageServices.dart';
import 'package:clientapp/domain/model/PackageStatus.dart';
import 'package:clientapp/domain/model/PackageType.dart';
import 'package:clientapp/domain/model/Role.dart';
import 'package:clientapp/domain/model/Service.dart';
import 'package:clientapp/domain/model/User.dart';
import 'package:clientapp/domain/model/Warehouse.dart';
import 'package:clientapp/domain/usecase/client/GetClientsUseCase.dart';
import 'package:clientapp/domain/usecase/client/GetCurrentClientUseCase.dart';
import 'package:clientapp/domain/usecase/delivery_person/get_delivery_personal_use_case.dart';
import 'package:clientapp/domain/usecase/pack/AddPackageUseCase.dart';
import 'package:clientapp/domain/usecase/package_paytype/get_package_paytype_use_case.dart';
import 'package:clientapp/domain/usecase/package_type/GetPackageTypesUseCase.dart';
import 'package:clientapp/domain/usecase/service/AddPackageServicesUseCase.dart';
import 'package:clientapp/domain/usecase/service/GetAllServicesUseCase.dart';
import 'package:clientapp/domain/usecase/transport_type/GetTransportTypesUseCase.dart';
import 'package:clientapp/domain/usecase/user/GetCurrentUserUseCase.dart';
import 'package:clientapp/domain/usecase/warehouse/get_warehouses_use_case.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SendPackageController {
  final ValueNotifier<List<PackageType>> packageTypes = ValueNotifier(<PackageType>[]);
  final ValueNotifier<List<Client>> clients = ValueNotifier(<Client>[]);
  final ValueNotifier<List<PackagePaytype>> paytypes = ValueNotifier(<PackagePaytype>[]);
  final GetPackageTypesUseCase getPackageTypesUseCase;
  final AddPackageUseCase addPackageUseCase;
  final GetCurrentClientUseCase getCurrentClientUseCase;
  final GetClientsUseCase getClientsUseCase;
  final GetAllServicesUseCase getAllServicesUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final GetPackagePaytypesUseCase getPackagePaytypesUseCase;
  final GetDeliveryPersonalUseCase getDeliveryPersonalUseCase;
  final GetWarehousesUseCase getWarehousesUseCase;
  final AddPackageServicesUseCase addPackageServicesUseCase;

  late List<Client> allClients;
  late User currUser;
  late Client selectedClient;
  late int payer;
  late List<PackageType> types;
  late PackagePaytype paytype;
  late List<DeliveryPerson> deliveryPersonal;
  late DeliveryPerson deliveryPerson;
  late List<Warehouse> warehouses;
  List<Service> selectedServices = List.empty(growable: true);

  var items = ValueNotifier(<PackageItem>[]);
  var services = ValueNotifier(<Service>[]);

  var itemName = ValueNotifier("");
  var itemDesc = ValueNotifier("");
  var itemLength = ValueNotifier(0.0);
  var itemWidth = ValueNotifier(0.0);
  var itemHeigth = ValueNotifier(0.0);
  var itemWeight = ValueNotifier(0.0);

  SendPackageController({
    required this.getPackageTypesUseCase,
    required this.addPackageUseCase,
    required this.getCurrentClientUseCase,
    required this.getClientsUseCase,
    required this.getAllServicesUseCase,
    required this.getCurrentUserUseCase,
    required this.getPackagePaytypesUseCase,
    required this.getDeliveryPersonalUseCase,
    required this.getWarehousesUseCase,
    required this.addPackageServicesUseCase
  });

  Future<void> populatelLists() async {
    packageTypes.value = await getPackageTypesUseCase.exec();
    currUser = await getCurrentUserUseCase.exec();
    var client = await getClientsUseCase.exec();
    allClients = await getClientsUseCase.exec();
    client.removeWhere((item) => item.client_user.user_id == currUser.user_id);
    services.value = await getAllServicesUseCase.exec();
    clients.value = client;
    types = await getPackageTypesUseCase.exec();
    paytypes.value = await getPackagePaytypesUseCase.exec();
    deliveryPersonal = await getDeliveryPersonalUseCase.exec();
    warehouses = await getWarehousesUseCase.exec();
  }

  Future<bool> addPackage() async {
    late Client payerCl;
    late PackageType type;
    late Warehouse warehouse;

    if (payer == 1) {
      payerCl = await getCurrentClientUseCase.exec();
    }
    if (payer == 2) {
      payerCl = selectedClient;
    }

    var v = items.value.fold<double>(0, (prev, item) => item.item_length! * item.item_weight! * item.item_heigth!);

    for (var t in types) {
      if (t.type_height! * t.type_width! * t.type_length! >= v) {
        type = t;
        break;
      }
    }

    for (var d in deliveryPersonal) {
      if (d.person_transport?.transport_status?.status_id == 1) {
        deliveryPerson = d;
        break;
      }
    }

    for (var w in warehouses) {
      if (w.warehouse_type?.type_id == type.type_id! + 1) {
        warehouse = w;
        break;
      }
    }

    Package pack = Package(
        package_uuid: "db78ee80-09a0-4cfc-9491-70b4ad3768cc",
        package_deliveryperson: deliveryPerson,
        package_payer: payerCl,
        package_paytype: paytype,
        package_send_date: DateTime.now(),
        package_receive_date: DateTime.now().add(const Duration(days: 7)),
        package_status: PackageStatus(status_id: 1, status_name: "Упаковка"),
        package_weight: items.value.fold<double>(0, (prev, el) => prev + el.item_weight!),
        package_receiver: selectedClient,
        package_warehouse: warehouse,
        package_type: type,
        package_sender: await getCurrentClientUseCase.exec(),
        package_items: items.value
    );

    await addPackageUseCase.exec(pack);

    for (var serv in selectedServices) {
      await addPackageServicesUseCase.exec(PackageServices(
          package: pack,
          service: serv,
          service_count: 1
      ));
    }

    return true;
  }
}
