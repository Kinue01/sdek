import 'package:clientapp/domain/model/Warehouse.dart';
import 'package:clientapp/domain/repository/warehouse_repository.dart';

class GetWarehousesUseCase {
  final WarehouseRepository repository;

  GetWarehousesUseCase({
    required this.repository
  });

  Future<List<Warehouse>> exec() async {
    return repository.getWarehouses();
  }
}