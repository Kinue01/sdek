import 'package:clientapp/domain/model/Role.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/model/User.dart';

abstract class UserLocalStorage {
  Future<bool> saveUser(User user);
  Future<bool> saveUsers(List<User> users);
  Future<List<User>> getUsers();
  Future<User> getUser(String uuid);
  Future<bool> saveCurrentUser(User user);
  Future<User> getCurrentUser();
}

class UserLocalStorageImpl implements UserLocalStorage {
  final SharedPreferencesAsync sharedPreferencesAsync;

  UserLocalStorageImpl({
    required this.sharedPreferencesAsync
  });

  @override
  Future<User> getUser(String uuid) async {
    final user = await sharedPreferencesAsync.getString("USER_$uuid");
    return user != null ? User.fromRawJson(user) : User(user_role: Role());
  }

  @override
  Future<List<User>> getUsers() async {
    final users = await sharedPreferencesAsync.getStringList("USERS");
    return users != null ? users.map((e) => User.fromRawJson(e)).toList() : [];
  }

  @override
  Future<bool> saveUser(User user) async {
    final key = user.user_id;
    final userStr = user.toRawJson();
    await sharedPreferencesAsync.setString("USER_$key", userStr);
    return true;
  }

  @override
  Future<bool> saveUsers(List<User> users) async {
    await sharedPreferencesAsync.setStringList("USERS", users.map((e) => e.toRawJson()).toList());
    return true;
  }
  
  @override
  Future<User> getCurrentUser() async {
    var res = await sharedPreferencesAsync.getString("CURR_USER");
    return res != null ? User.fromRawJson(res) : User(user_role: Role());
  }
  
  @override
  Future<bool> saveCurrentUser(User user) async {
    await sharedPreferencesAsync.setString("CURR_USER", user.toRawJson());
    return true;
  }
}