import 'package:clientapp/domain/model/PackageStatus.dart';
import 'package:clientapp/domain/repository/package_status_repository.dart';

class GetPackageStatusByIdUseCase {
  PackageStatusRepository repository;

  GetPackageStatusByIdUseCase({
    required this.repository
  });

  Future<PackageStatus> exec(int id) async {
    return await repository.getPackageStatusById(id);
  }
}