import 'package:clientapp/data/repository/WarehouseTypeDataRepository.dart';
import 'package:clientapp/domain/model/WarehouseType.dart';
import 'package:clientapp/remote/api/warehouse_api.dart';

class WarehouseTypeDataRepositoryImpl implements WarehouseTypeDataRepository {
  final WarehouseApi api;

  WarehouseTypeDataRepositoryImpl({
    required this.api
  });

  @override
  Future<List<WarehouseType>> getTypes() async {
    return await api.getTypes();
  }
}