import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/model/Role.dart';

abstract class RoleLocalStorage {
  Future<bool> saveRoles(List<Role> roles);
  Future<bool> saveRole(Role role);
  Future<List<Role>> getRoles();
  Future<Role> getRole(int id);
}

class RoleLocalStorageImpl implements RoleLocalStorage {
  final SharedPreferencesAsync sharedPreferencesAsync;

  RoleLocalStorageImpl({
    required this.sharedPreferencesAsync
  });

  @override
  Future<Role> getRole(int id) async {
    final role = await sharedPreferencesAsync.getString("ROLE_$id");
    return role != null ? Role.fromRawJson(role) : Role();
  }

  @override
  Future<List<Role>> getRoles() async {
    final roles = await sharedPreferencesAsync.getStringList("ROLES");
    return roles != null ? roles.map((e) => Role.fromRawJson(e)).toList() : [];
  }

  @override
  Future<bool> saveRole(Role role) async {
    final roleStr = role.toRawJson();
    final key = role.role_id;
    await sharedPreferencesAsync.setString("ROLE_$key", roleStr);
    return true;
  }

  @override
  Future<bool> saveRoles(List<Role> roles) async {
    await sharedPreferencesAsync.setStringList("ROLES", roles.map((e) => e.toRawJson()).toList());
    return true;
  }
}