import 'package:clientapp/data/repository/warehouse_data_repository.dart';
import 'package:clientapp/domain/model/Warehouse.dart';
import 'package:clientapp/domain/repository/warehouse_repository.dart';

class WarehouseRepositoryImpl implements WarehouseRepository {
  final WarehouseDataRepository repository;

  WarehouseRepositoryImpl({
    required this.repository
  });

  @override
  Future<Warehouse> getWarehouseById(int id) {
    // TODO: implement getWarehouseById
    throw UnimplementedError();
  }

  @override
  Future<List<Warehouse>> getWarehouses() async {
    return repository.getWarehouses();
  }
}