import 'package:clientapp/domain/model/PackageType.dart';

abstract class PackageTypeRepository {
  Future<List<PackageType>> getTypes();
  Future<PackageType> getTypeById(int id);
  Future<bool> addType(PackageType type);
  Future<bool> updateType(PackageType type);
  Future<bool> deleteType(PackageType type);
}