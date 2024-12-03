import '../../domain/model/PackagePaytype.dart';

abstract class PackagePaytypeDataRepository {
  Future<List<PackagePaytype>> getAllPaytypes();
  Future<PackagePaytype> getPaytypeById(int id);
}