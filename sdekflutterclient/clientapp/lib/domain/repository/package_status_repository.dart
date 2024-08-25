import 'package:clientapp/domain/model/PackageStatus.dart';

abstract class PackageStatusRepository {
  Future<List<PackageStatus>> getStatuses();
  Future<PackageStatus> getPackageStatusById(int id);
  Future<bool> addStatus(PackageStatus status);
  Future<bool> updateStatus(PackageStatus status);
  Future<bool> deleteStatus(PackageStatus status);
}