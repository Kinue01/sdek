import 'package:clientapp/domain/model/PackageStatus.dart';
import 'package:clientapp/domain/repository/package_status_repository.dart';

class UpdatePackageStatusUseCase {
  PackageStatusRepository repository;

  UpdatePackageStatusUseCase({
    required this.repository
  });

  Future<bool> exec(PackageStatus status) async {
    return await repository.updateStatus(status);
  }
}