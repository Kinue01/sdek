import 'package:clientapp/data/repository/warehouse_data_repository.dart';
import 'package:clientapp/domain/model/Warehouse.dart';
import 'package:clientapp/remote/api/warehouse_api.dart';

class WarehouseDataRepositoryImpl implements WarehouseDataRepository {
  final WarehouseApi api;

  WarehouseDataRepositoryImpl({
    required this.api
  });

  @override
  Future<Warehouse> getWarehouseById(int id) async {
    return await api.getWarehouseById(id);
  }

  @override
  Future<List<Warehouse>> getWarehouses() async {
    return api.getWarehouses();
  }

  @override
  Future<void> addWarehouse(Warehouse warehouse) async {
    return await api.addWarehouse(warehouse);
  }

  @override
  Future<void> deleteWarehouse(Warehouse warehouse) async {
    return await api.deleteWarehouse(warehouse);
  }

  @override
  Future<void> updateWarehouse(Warehouse warehouse) async {
    return await api.updateWarehouse(warehouse);
  }
}