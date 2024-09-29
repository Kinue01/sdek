import 'package:clientapp/domain/model/Package.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PackageLocalStorage {
  Future<bool> savePackage(Package package);
  Future<bool> savePackages(List<Package> packages);
  Future<List<Package>> getPackages();
  Future<Package> getPackage(String uuid);
}

class PackageLocalStorageImpl implements PackageLocalStorage {
  final SharedPreferencesAsync sharedPreferencesAsync;

  PackageLocalStorageImpl({
    required this.sharedPreferencesAsync
  });

  @override
  Future<Package> getPackage(String uuid) async {
    final pack = await sharedPreferencesAsync.getString("PACK_$uuid");
    return pack != null ? Package.fromRawJson(pack) : Package();
  }

  @override
  Future<List<Package>> getPackages() async {
    final packs = await sharedPreferencesAsync.getStringList("PACKS");
    return packs != null ? packs.map((e) => Package.fromRawJson(e)).toList() : [];
  }

  @override
  Future<bool> savePackage(Package package) async {
    final key = package.package_uuid;
    final json = package.toRawJson();
    await sharedPreferencesAsync.setString("PACK_$key", json);
    return true;
  }

  @override
  Future<bool> savePackages(List<Package> packages) async {
    await sharedPreferencesAsync.setStringList("PACKS", packages.map((e) => e.toRawJson()).toList());
    return true;
  }
}