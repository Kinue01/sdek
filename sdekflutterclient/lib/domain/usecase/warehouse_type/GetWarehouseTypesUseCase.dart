import 'package:clientapp/domain/model/WarehouseType.dart';
import 'package:clientapp/domain/repository/WarehouseTypeRepository.dart';

class GetWarehouseTypesUseCase {
  final WarehouseTypeRepository repository;

  GetWarehouseTypesUseCase({
    required this.repository
  });

  Future<List<WarehouseType>> exec() async {
    return await repository.getTypes();
  }
}