import 'package:clientapp/domain/model/WarehouseType.dart';

abstract class WarehouseTypeRepository {
  Future<List<WarehouseType>> getTypes();
}