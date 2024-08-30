import 'package:clientapp/domain/model/Package.dart';
import 'package:clientapp/domain/repository/package_repository.dart';

class DeletePackageUseCase {
  PackageRepository repository;

  DeletePackageUseCase({
    required this.repository
  });

  Future<bool> exec(Package package) async {
    return await repository.deletePackage(package);
  }
}