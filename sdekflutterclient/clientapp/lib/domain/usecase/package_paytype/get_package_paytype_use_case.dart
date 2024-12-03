import 'package:clientapp/domain/model/PackagePaytype.dart';
import 'package:clientapp/domain/repository/package_paytype_repository.dart';

class GetPackagePaytypesUseCase {
  final PackagePaytypeRepository repository;

  GetPackagePaytypesUseCase({
    required this.repository
  });

  Future<List<PackagePaytype>> exec() async {
    return repository.getAllPaytypes();
  }
}