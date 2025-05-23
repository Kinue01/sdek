import 'package:clientapp/data/repository/WarehouseTypeDataRepository.dart';
import 'package:clientapp/domain/model/WarehouseType.dart';
import 'package:clientapp/domain/repository/WarehouseTypeRepository.dart';

class WarehouseTypeRepositoryImpl implements WarehouseTypeRepository {
  final WarehouseTypeDataRepository repository;

  WarehouseTypeRepositoryImpl({
    required this.repository
  });

  @override
  Future<List<WarehouseType>> getTypes() async {
    return await repository.getTypes();
  }
}