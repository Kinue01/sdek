import 'package:clientapp/data/repository/package_type_data_repository.dart';
import 'package:clientapp/domain/model/PackageType.dart';
import 'package:clientapp/domain/repository/package_type_repository.dart';
import 'package:clientapp/local/local_storage/package_type_local_storage.dart';

class PackageTypeRepositoryImpl implements PackageTypeRepository {
  PackageTypeDataRepository repository;
  PackageTypeLocalStorage packageTypeLocalStorage;

  PackageTypeRepositoryImpl({
    required this.repository,
    required this.packageTypeLocalStorage
  });

  @override
  Future<bool> addType(PackageType type) async {
    if (await repository.addType(type)) {
      await packageTypeLocalStorage.savePackageType(type);
      return true;
    }
    else {
      return false;
    }
  }

  @override
  Future<bool> deleteType(PackageType type) async {
    if (await repository.deleteType(type)) {
      await packageTypeLocalStorage.savePackageType(PackageType());
      return true;
    }
    else {
      return false;
    }
  }

  @override
  Future<PackageType> getTypeById(int id) async {
    final type = await packageTypeLocalStorage.getPackageType(id);
    if (type.type_id != 0) {
      return type;
    }
    else {
      final res = await repository.getTypeById(id);
      if (res.type_id != 0) {
        await packageTypeLocalStorage.savePackageType(res);
      }
      return res;
    }
  }

  @override
  Future<List<PackageType>> getTypes() async {
    final types = await packageTypeLocalStorage.getPackageTypes();
    if (types != []) {
      return types;
    }
    else {
      final res = await repository.getTypes();
      if (res != List.empty()) {
        await packageTypeLocalStorage.savePackageTypes(res);
      }
      return res;
    }
  }

  @override
  Future<bool> updateType(PackageType type) async {
    if (await repository.updateType(type)) {
      await packageTypeLocalStorage.savePackageType(type);
      return true;
    }
    else {
      return false;
    }
  }
}