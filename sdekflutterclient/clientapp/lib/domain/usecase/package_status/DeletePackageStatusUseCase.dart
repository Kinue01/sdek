import 'package:clientapp/domain/model/PackageStatus.dart';
import 'package:clientapp/domain/repository/package_status_repository.dart';

class DeletePackageStatusUseCase {
  PackageStatusRepository repository;

  DeletePackageStatusUseCase({
    required this.repository
  });

  Future<bool> exec(PackageStatus status) async {
    return await repository.deleteStatus(status);
  }
}