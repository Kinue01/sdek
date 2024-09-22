import 'package:clientapp/domain/model/Package.dart';
import 'package:uuid/uuid.dart';

abstract class PackageRepository {
  Future<List<Package>> getPackages();
  Future<Package> getPackageById(Uuid uuid);
  Future<List<Package>> getPackagesByClientId(int id);
  Future<bool> addPackage(Package package);
  Future<bool> updatePackage(Package package);
  Future<bool> deletePackage(Package package);
}