import 'package:clientapp/domain/model/Package.dart';
import 'package:clientapp/domain/repository/package_repository.dart';

class UpdatePackageUseCase {
  PackageRepository repository;

  UpdatePackageUseCase({
    required this.repository
  });

  Future<bool> exec(Package package) async {
    return await repository.updatePackage(package);
  }
}