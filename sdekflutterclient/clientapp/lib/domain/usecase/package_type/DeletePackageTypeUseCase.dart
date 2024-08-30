import 'package:clientapp/domain/model/PackageType.dart';
import 'package:clientapp/domain/repository/package_type_repository.dart';

class DeletePackageTypeUseCase {
  PackageTypeRepository repository;

  DeletePackageTypeUseCase({
    required this.repository
  });

  Future<bool> exec(PackageType type) async {
    return await repository.deleteType(type);
  }
}