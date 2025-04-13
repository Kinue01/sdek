import '../model/Warehouse.dart';

abstract class WarehouseRepository {
  Future<List<Warehouse>> getWarehouses();
  Future<Warehouse> getWarehouseById(int id);
}