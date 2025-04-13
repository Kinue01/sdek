import 'package:clientapp/domain/model/PackageStatus.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PackageStatusLocalStorage {
  Future<bool> savePackageStatus(PackageStatus status);
  Future<bool> savePackageStatuses(List<PackageStatus> statuses);
  Future<List<PackageStatus>> getPackageStatuses();
  Future<PackageStatus> getPackageStatus(int id);
}

class PackageStatusLocalStorageImpl implements PackageStatusLocalStorage {
  final SharedPreferencesAsync sharedPreferencesAsync;

  PackageStatusLocalStorageImpl({
    required this.sharedPreferencesAsync
  });

  @override
  Future<PackageStatus> getPackageStatus(int id) async {
    final status = await sharedPreferencesAsync.getString("PACK_STATUS_$id");
    return status != null ? PackageStatus.fromRawJson(status) : PackageStatus();
  }

  @override
  Future<List<PackageStatus>> getPackageStatuses() async {
    final statuses = await sharedPreferencesAsync.getStringList("PACK_STATUSES");
    return statuses != null ? statuses.map((e) => PackageStatus.fromRawJson(e)).toList() : [];
  }

  @override
  Future<bool> savePackageStatus(PackageStatus status) async {
    final key = status.status_id;
    final json = status.toRawJson();
    await sharedPreferencesAsync.setString("PACK_STATUS_$key", json);
    return true;
  }

  @override
  Future<bool> savePackageStatuses(List<PackageStatus> statuses) async {
    await sharedPreferencesAsync.setStringList("PACK_STATUSES", statuses.map((e) => e.toRawJson()).toList());
    return true;
  }
}