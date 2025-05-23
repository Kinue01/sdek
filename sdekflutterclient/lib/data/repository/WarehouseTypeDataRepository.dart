import '../../domain/model/WarehouseType.dart';

abstract class WarehouseTypeDataRepository {
  Future<List<WarehouseType>> getTypes();
}