import 'package:clientapp/data/repository/warehouse_data_repository.dart';
import 'package:clientapp/domain/model/Warehouse.dart';
import 'package:clientapp/domain/repository/warehouse_repository.dart';

class WarehouseRepositoryImpl implements WarehouseRepository {
  final WarehouseDataRepository repository;

  WarehouseRepositoryImpl({
    required this.repository
  });

  @override
  Future<Warehouse> getWarehouseById(int id) async {
    return await repository.getWarehouseById(id);
  }

  @override
  Future<List<Warehouse>> getWarehouses() async {
    return repository.getWarehouses();
  }

  @override
  Future<void> addWarehouse(Warehouse warehouse) async {
    await repository.addWarehouse(warehouse);
  }

  @override
  Future<void> deleteWarehouse(Warehouse warehouse) async {
    await repository.deleteWarehouse(warehouse);
  }

  @override
  Future<void> updateWarehouse(Warehouse warehouse) async {
    await repository.updateWarehouse(warehouse);
  }
}