import '../model/PackagePaytype.dart';

abstract class PackagePaytypeRepository {
  Future<List<PackagePaytype>> getAllPaytypes();
  Future<PackagePaytype> getPaytypeById(int id);
}