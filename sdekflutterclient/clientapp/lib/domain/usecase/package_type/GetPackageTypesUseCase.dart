import 'package:clientapp/domain/model/PackageType.dart';
import 'package:clientapp/domain/repository/package_type_repository.dart';

class GetPackageTypesUseCase {
  PackageTypeRepository repository;

  GetPackageTypesUseCase({
    required this.repository
  });

  Future<List<PackageType>> exec() async {
    return await repository.getTypes();
  }
}