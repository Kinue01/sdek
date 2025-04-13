import 'package:clientapp/domain/model/User.dart';
import 'package:dio/dio.dart';

import '../../domain/model/Role.dart';

abstract class UserApi {
  Future<List<User>> getUsers();
  Future<User> getUserById(String uuid);
  Future<bool> addUser(User user);
  Future<bool> updateUser(User user);
  Future<bool> deleteUser(User user);
}

class UserApiImpl implements UserApi {
  final Dio client;

  UserApiImpl({
    required this.client
  });

  String get url => "http://localhost/userservice";
  String get readUrl => "http://localhost/userreadservice";

  @override
  Future<bool> addUser(User user) async {
    Response resp = await client.post("$url/api/user", data: user.toRawJson());
    if (resp.statusCode == 201) {
      return true;
    }
    else {
      return false;
    }
  }

  @override
  Future<bool> deleteUser(User user) async {
    Response resp = await client.delete("$url/api/user", data: user.toRawJson());
    if (resp.statusCode == 200) {
      return true;
    }
    else {
      return false;
    }
  }

  @override
  Future<User> getUserById(String uuid) async {
    Response<Map<String, dynamic>> resp = await client.get("$readUrl/api/user", options: Options(extra: {'uuid': uuid}));
    if (resp.statusCode == 200) {
      return User.fromMap(resp.data!);
    }
    else {
      return User(user_role: Role());
    }
  }

  @override
  Future<List<User>> getUsers() async {
    Response<List<Map<String, dynamic>>> resp = await client.get("$readUrl/api/user");
    if (resp.statusCode == 200) {
      return resp.data!.map((e) => User.fromMap(e)).toList();
    }
    else {
      return List.empty();
    }
  }

  @override
  Future<bool> updateUser(User user) async {
    Response response = await client.patch("$url/api/user", data: user.toRawJson());
    if (response.statusCode == 200) {
      return true;
    }
    else {
      return false;
    }
  }
}