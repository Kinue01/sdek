import 'package:clientapp/domain/model/PackageType.dart';
import 'package:clientapp/domain/repository/package_type_repository.dart';

class GetPackageTypeByIdUseCase {
  PackageTypeRepository repository;

  GetPackageTypeByIdUseCase({
    required this.repository
  });

  Future<PackageType> exec(int id) async {
    return await repository.getTypeById(id);
  }
}