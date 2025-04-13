import 'package:clientapp/data/repository/package_type_data_repository.dart';
import 'package:clientapp/domain/model/PackageType.dart';
import 'package:clientapp/remote/api/package_type_api.dart';

class PackageTypeDataRepositoryImpl implements PackageTypeDataRepository {
  PackageTypeApi packageTypeApi;

  PackageTypeDataRepositoryImpl({
    required this.packageTypeApi
  });

  @override
  Future<bool> addType(PackageType type) async {
    return await packageTypeApi.addType(type);
  }

  @override
  Future<bool> deleteType(PackageType type) async {
    return await packageTypeApi.deleteType(type);
  }

  @override
  Future<PackageType> getTypeById(int id) async {
    return await packageTypeApi.getTypeById(id);
  }

  @override
  Future<List<PackageType>> getTypes() async {
    return await packageTypeApi.getTypes();
  }

  @override
  Future<bool> updateType(PackageType type) async {
    return await packageTypeApi.updateType(type);
  }
}