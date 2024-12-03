import '../../domain/model/Warehouse.dart';

abstract class WarehouseDataRepository {
  Future<List<Warehouse>> getWarehouses();
  Future<Warehouse> getWarehouseById(int id);
}