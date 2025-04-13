import 'package:clientapp/data/repository/package_paytype_data_repository.dart';
import 'package:clientapp/domain/model/PackagePaytype.dart';
import 'package:clientapp/remote/api/package_paytype_api.dart';

class PackagePaytypeDataRepositoryImpl implements PackagePaytypeDataRepository {
  final PackagePaytypeApi api;

  PackagePaytypeDataRepositoryImpl({
    required this.api
  });

  @override
  Future<List<PackagePaytype>> getAllPaytypes() async {
    return await api.getAllPaytypes();
  }

  @override
  Future<PackagePaytype> getPaytypeById(int id) {
    // TODO: implement getPaytypeById
    throw UnimplementedError();
  }
}