import 'package:clientapp/domain/model/PackageType.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PackageTypeLocalStorage {
  Future<bool> savePackageType(PackageType type);
  Future<bool> savePackageTypes(List<PackageType> types);
  Future<PackageType> getPackageType(int id);
  Future<List<PackageType>> getPackageTypes();
}

class PackageTypeLocalStorageImpl implements PackageTypeLocalStorage {
  final SharedPreferencesAsync sharedPreferencesAsync;

  PackageTypeLocalStorageImpl({
    required this.sharedPreferencesAsync
  });

  @override
  Future<PackageType> getPackageType(int id) async {
    final type = await sharedPreferencesAsync.getString("PACK_TYPE_$id");
    return type != null ? PackageType.fromRawJson(type) : PackageType();
  }

  @override
  Future<List<PackageType>> getPackageTypes() async {
    final types = await sharedPreferencesAsync.getStringList("PACK_TYPES");
    return types != null ? types.map((e) => PackageType.fromRawJson(e)).toList() : [];
  }

  @override
  Future<bool> savePackageType(PackageType type) async {
    final key = type.type_id;
    final json = type.toRawJson();
    await sharedPreferencesAsync.setString("PACK_TYPE_$key", json);
    return true;
  }

  @override
  Future<bool> savePackageTypes(List<PackageType> types) async {
    await sharedPreferencesAsync.setStringList("PACK_TYPES", types.map((e) => e.toRawJson()).toList());
    return true;
  }
}