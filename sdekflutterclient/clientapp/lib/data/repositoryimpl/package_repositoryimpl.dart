import 'package:clientapp/data/repository/package_data_repository.dart';
import 'package:clientapp/domain/model/Package.dart';
import 'package:clientapp/domain/repository/package_repository.dart';
import 'package:uuid/uuid.dart';

class PackageRepositoryImpl implements PackageRepository {
  PackageDataRepository repository;

  PackageRepositoryImpl({
    required this.repository
  });

  @override
  Future<bool> addPackage(Package package) async {
    return await repository.addPackage(package);
  }

  @override
  Future<bool> deletePackage(Package package) async {
    return await repository.deletePackage(package);
  }

  @override
  Future<Package> getPackageById(Uuid uuid) async {
    return await repository.getPackageById(uuid);
  }

  @override
  Future<List<Package>> getPackages() async {
    return await repository.getPackages();
  }

  @override
  Future<List<Package>> getPackagesByClientId(int id) async {
    return await repository.getPackagesByClientId(id);
  }

  @override
  Future<bool> updatePackage(Package package) async {
    return await repository.updatePackage(package);
  }
}