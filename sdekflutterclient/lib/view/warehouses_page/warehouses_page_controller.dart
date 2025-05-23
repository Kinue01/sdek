import 'package:clientapp/domain/model/Warehouse.dart';
import 'package:clientapp/domain/model/WarehouseType.dart';
import 'package:clientapp/domain/usecase/warehouse/AddWarehouseUseCase.dart';
import 'package:clientapp/domain/usecase/warehouse/DeleteWarehouseUseCase.dart';
import 'package:clientapp/domain/usecase/warehouse/UpdateWarehouseUseCase.dart';
import 'package:clientapp/domain/usecase/warehouse/get_warehouses_use_case.dart';
import 'package:clientapp/domain/usecase/warehouse_type/GetWarehouseTypesUseCase.dart';
import 'package:flutter/cupertino.dart';

class WarehousePageController {
  final warehouses = ValueNotifier(<Warehouse>[]);
  final warehouseTypes = ValueNotifier(<WarehouseType>[]);

  final GetWarehousesUseCase getWarehousesUseCase;
  final AddWarehouseUseCase addWarehouseUseCase;
  final UpdateWarehouseUseCase updateWarehouseUseCase;
  final DeleteWarehouseUseCase deleteWarehouseUseCase;
  final GetWarehouseTypesUseCase getWarehouseTypesUseCase;
  WarehousePageController({
    required this.getWarehousesUseCase,
    required this.addWarehouseUseCase,
    required this.updateWarehouseUseCase,
    required this.deleteWarehouseUseCase,
    required this.getWarehouseTypesUseCase
  });

  Future<void> init() async {
    warehouses.value = await getWarehousesUseCase.exec();
    warehouseTypes.value = await getWarehouseTypesUseCase.exec();
  }

  Future<void> addWarehouse(Warehouse warehouse) async {
    await addWarehouseUseCase.exec(warehouse);
  }

  Future<void> updateWarehouse(Warehouse warehouse) async {
    await updateWarehouseUseCase.exec(warehouse);
  }

  Future<void> deleteWarehouse(Warehouse warehouse) async {
    await deleteWarehouseUseCase.exec(warehouse);
  }
}