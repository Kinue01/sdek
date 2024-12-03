import 'package:clientapp/data/repository/package_status_data_repository.dart';
import 'package:clientapp/domain/model/PackageStatus.dart';
import 'package:clientapp/domain/repository/package_status_repository.dart';
import 'package:clientapp/local/local_storage/package_status_local_storage.dart';

class PackageStatusRepositoryImpl implements PackageStatusRepository {
  PackageStatusDataRepository repository;
  PackageStatusLocalStorage packageStatusLocalStorage;

  PackageStatusRepositoryImpl({
    required this.repository,
    required this.packageStatusLocalStorage
  });

  @override
  Future<bool> addStatus(PackageStatus status) async {
    if (await repository.addStatus(status)) {
      //await packageStatusLocalStorage.savePackageStatus(status);
      return true;
    }
    else {
      return false;
    }
  }

  @override
  Future<bool> deleteStatus(PackageStatus status) async {
    if (await repository.deleteStatus(status)) {
      //await packageStatusLocalStorage.savePackageStatus(PackageStatus());
      return true;
    }
    else {
      return false;
    }
  }

  @override
  Future<PackageStatus> getPackageStatusById(int id) async {
    // final status = await packageStatusLocalStorage.getPackageStatus(id);
    // if (status.status_id != 0) {
    //   return status;
    // }
    // else {
    //   final res = await repository.getPackageStatusById(id);
    //   if (res.status_id != 0) {
    //     await packageStatusLocalStorage.savePackageStatus(res);
    //   }
    //   return res;
    // }
    return await repository.getPackageStatusById(id);
  }

  @override
  Future<List<PackageStatus>> getStatuses() async {
    // final statuses = await packageStatusLocalStorage.getPackageStatuses();
    // if (statuses != []) {
    //   return statuses;
    // }
    // else {
    //   final res = await repository.getStatuses();
    //   if (res != List.empty()) {
    //     await packageStatusLocalStorage.savePackageStatuses(res);
    //   }
    //   return res;
    // }
    return await repository.getStatuses();
  }

  @override
  Future<bool> updateStatus(PackageStatus status) async {
    if (await repository.updateStatus(status)) {
      //await packageStatusLocalStorage.savePackageStatus(status);
      return true;
    }
    else {
      return false;
    }
  }
}