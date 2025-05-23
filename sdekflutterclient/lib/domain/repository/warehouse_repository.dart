import '../model/Warehouse.dart';

abstract class WarehouseRepository {
  Future<List<Warehouse>> getWarehouses();
  Future<Warehouse> getWarehouseById(int id);
  Future<void> addWarehouse(Warehouse warehouse);
  Future<void> updateWarehouse(Warehouse warehouse);
  Future<void> deleteWarehouse(Warehouse warehouse);
}