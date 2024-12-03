import 'package:clientapp/data/repository/warehouse_data_repository.dart';
import 'package:clientapp/domain/model/Warehouse.dart';
import 'package:clientapp/remote/api/warehouse_api.dart';

class WarehouseDataRepositoryImpl implements WarehouseDataRepository {
  final WarehouseApi api;

  WarehouseDataRepositoryImpl({
    required this.api
  });

  @override
  Future<Warehouse> getWarehouseById(int id) {
    // TODO: implement getWarehouseById
    throw UnimplementedError();
  }

  @override
  Future<List<Warehouse>> getWarehouses() async {
    return api.getWarehouses();
  }
}