import 'package:clientapp/domain/model/PackageStatus.dart';
import 'package:clientapp/domain/repository/package_status_repository.dart';

class GetPackageStatusesUseCase {
  PackageStatusRepository repository;

  GetPackageStatusesUseCase({
    required this.repository
  });

  Future<List<PackageStatus>> exec() async {
    return await repository.getStatuses();
  }
}