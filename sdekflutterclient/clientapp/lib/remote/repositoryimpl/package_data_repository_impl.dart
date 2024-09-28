import 'package:clientapp/data/repository/package_data_repository.dart';
import 'package:clientapp/domain/model/Package.dart';
import 'package:clientapp/remote/api/package_api.dart';

class PackageDataRepositoryImpl implements PackageDataRepository {
  PackageApi packageApi;

  PackageDataRepositoryImpl({
    required this.packageApi
  });

  @override
  Future<bool> addPackage(Package package) async {
    return await packageApi.addPackage(package);
  }

  @override
  Future<bool> deletePackage(Package package) async {
    return await packageApi.deletePackage(package);
  }

  @override
  Future<Package> getPackageById(String uuid) async {
    return await packageApi.getPackageById(uuid);
  }

  @override
  Future<List<Package>> getPackages() async {
    return await packageApi.getPackages();
  }

  @override
  Future<List<Package>> getPackagesByClientId(int id) async {
    return await packageApi.getPackagesByClientId(id);
  }

  @override
  Future<bool> updatePackage(Package package) async {
    return await packageApi.updatePackage(package);
  }
}