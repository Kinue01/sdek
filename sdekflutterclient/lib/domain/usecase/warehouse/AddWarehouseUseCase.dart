import 'package:clientapp/domain/model/Warehouse.dart';
import 'package:clientapp/domain/repository/warehouse_repository.dart';

class AddWarehouseUseCase {
  final WarehouseRepository repository;

  AddWarehouseUseCase({
    required this.repository
  });

  Future<void> exec(Warehouse warehouse) async  {
    await repository.addWarehouse(warehouse);
  }
}