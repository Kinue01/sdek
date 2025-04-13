import 'package:clientapp/data/repository/package_status_data_repository.dart';
import 'package:clientapp/domain/model/PackageStatus.dart';
import 'package:clientapp/remote/api/package_status_api.dart';

class PackageStatusDataRepositoryImpl implements PackageStatusDataRepository {
  PackageStatusApi packageStatusApi;

  PackageStatusDataRepositoryImpl({
    required this.packageStatusApi
  });

  @override
  Future<bool> addStatus(PackageStatus status) async {
    return await packageStatusApi.addStatus(status);
  }

  @override
  Future<bool> deleteStatus(PackageStatus status) async {
    return await packageStatusApi.deleteStatus(status);
  }

  @override
  Future<PackageStatus> getPackageStatusById(int id) async {
    return await packageStatusApi.getPackageStatusById(id);
  }

  @override
  Future<List<PackageStatus>> getStatuses() async {
    return await packageStatusApi.getStatuses();
  }

  @override
  Future<bool> updateStatus(PackageStatus status) async {
    return await packageStatusApi.updateStatus(status);
  }
}