import 'package:clientapp/data/repository/package_data_repository.dart';
import 'package:clientapp/domain/model/Package.dart';
import 'package:clientapp/domain/repository/package_repository.dart';
import 'package:clientapp/local/local_storage/package_local_storage.dart';

class PackageRepositoryImpl implements PackageRepository {
  PackageDataRepository repository;
  PackageLocalStorage packageLocalStorage;

  PackageRepositoryImpl({
    required this.repository,
    required this.packageLocalStorage
  });

  @override
  Future<bool> addPackage(Package package) async {
    if (await repository.addPackage(package)) {
      await packageLocalStorage.savePackage(package);
      return true;
    }
    else {
      return false;
    }
  }

  @override
  Future<bool> deletePackage(Package package) async {
    if (await repository.deletePackage(package)) {
      await packageLocalStorage.savePackage(Package());
      return true;
    }
    else {
      return false;
    }
  }

  @override
  Future<Package> getPackageById(String uuid) async {
    final pack = await packageLocalStorage.getPackage(uuid);
    if (pack.package_uuid != "") {
      return pack;
    }
    else {
      final res = await repository.getPackageById(uuid);
      if (res.package_uuid != "") {
        await packageLocalStorage.savePackage(res);
      }
      return res;
    }
  }

  @override
  Future<List<Package>> getPackages() async {
    final packs = await packageLocalStorage.getPackages();
    if (packs != []) {
      return packs;
    }
    else {
      final res = await repository.getPackages();
      if (res != List.empty()) {
        await packageLocalStorage.savePackages(res);
      }
      return res;
    }
  }

  // ЧЁ-ТО ПРИДУМАТЬ, ПЛЮС НАДО КАК-ТО УДАЛЯТЬ ИЗ КЕША ДАННЫЕ
  @override
  Future<List<Package>> getPackagesByClientId(int id) async {
    return await repository.getPackagesByClientId(id);
  }

  @override
  Future<bool> updatePackage(Package package) async {
    if (await repository.updatePackage(package)) {
      await packageLocalStorage.savePackage(package);
      return true;
    }
    else {
      return false;
    }
  }
}