import 'package:clientapp/data/repository/package_type_data_repository.dart';
import 'package:clientapp/domain/model/PackageType.dart';
import 'package:clientapp/domain/repository/package_type_repository.dart';

class PackageTypeRepositoryImpl implements PackageTypeRepository {
  PackageTypeDataRepository repository;

  PackageTypeRepositoryImpl({
    required this.repository
  });

  @override
  Future<bool> addType(PackageType type) async {
    return await repository.addType(type);
  }

  @override
  Future<bool> deleteType(PackageType type) async {
    return await repository.deleteType(type);
  }

  @override
  Future<PackageType> getTypeById(int id) async {
    return await repository.getTypeById(id);
  }

  @override
  Future<List<PackageType>> getTypes() async {
    return await repository.getTypes();
  }

  @override
  Future<bool> updateType(PackageType type) async {
    return await repository.updateType(type);
  }
}