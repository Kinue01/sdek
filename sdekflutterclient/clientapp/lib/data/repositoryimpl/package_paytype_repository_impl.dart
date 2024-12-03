import 'package:clientapp/data/repository/package_paytype_data_repository.dart';
import 'package:clientapp/domain/model/PackagePaytype.dart';
import 'package:clientapp/domain/repository/package_paytype_repository.dart';

class PackagePaytypeRepositoryImpl implements PackagePaytypeRepository {
  final PackagePaytypeDataRepository repository;

  PackagePaytypeRepositoryImpl({
    required this.repository
  });

  @override
  Future<List<PackagePaytype>> getAllPaytypes() async {
    return await repository.getAllPaytypes();
  }

  @override
  Future<PackagePaytype> getPaytypeById(int id) {
    // TODO: implement getPaytypeById
    throw UnimplementedError();
  }
}