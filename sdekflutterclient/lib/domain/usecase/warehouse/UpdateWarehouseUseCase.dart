import 'package:clientapp/domain/model/Warehouse.dart';
import 'package:clientapp/domain/repository/warehouse_repository.dart';

class UpdateWarehouseUseCase {
  final WarehouseRepository repository;

  UpdateWarehouseUseCase({
    required this.repository
  });

  Future<void> exec(Warehouse warehouse) async {
    await repository.updateWarehouse(warehouse);
  }
}