import 'package:clientapp/data/repository/package_status_data_repository.dart';
import 'package:clientapp/domain/model/PackageStatus.dart';
import 'package:clientapp/domain/repository/package_status_repository.dart';

class PackageStatusRepositoryImpl implements PackageStatusRepository {
  PackageStatusDataRepository repository;

  PackageStatusRepositoryImpl({
    required this.repository
  });

  @override
  Future<bool> addStatus(PackageStatus status) async {
    return await repository.addStatus(status);
  }

  @override
  Future<bool> deleteStatus(PackageStatus status) async {
    return await repository.deleteStatus(status);
  }

  @override
  Future<PackageStatus> getPackageStatusById(int id) async {
    return await repository.getPackageStatusById(id);
  }

  @override
  Future<List<PackageStatus>> getStatuses() async {
    return await repository.getStatuses();
  }

  @override
  Future<bool> updateStatus(PackageStatus status) async {
    return await repository.updateStatus(status);
  }
}