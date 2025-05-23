import 'package:clientapp/domain/model/Warehouse.dart';
import 'package:clientapp/domain/repository/warehouse_repository.dart';

class DeleteWarehouseUseCase {
  final WarehouseRepository repository;

  DeleteWarehouseUseCase({
    required this.repository
  });

  Future<void> exec(Warehouse warehouse) async {
    await repository.deleteWarehouse(warehouse);
  }
}
