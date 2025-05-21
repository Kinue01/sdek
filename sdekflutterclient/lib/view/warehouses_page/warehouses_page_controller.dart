import 'package:clientapp/domain/model/Warehouse.dart';
import 'package:clientapp/domain/usecase/warehouse/get_warehouses_use_case.dart';
import 'package:flutter/cupertino.dart';

class WarehousePageController {
  final warehouses = ValueNotifier(<Warehouse>[]);

  final GetWarehousesUseCase getWarehousesUseCase;
  WarehousePageController({
    required this.getWarehousesUseCase
  });

  Future<void> init() async {
    warehouses.value = await getWarehousesUseCase.exec();
  }
}