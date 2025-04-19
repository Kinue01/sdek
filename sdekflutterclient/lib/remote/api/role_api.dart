import 'package:clientapp/domain/model/Role.dart';
import 'package:dio/dio.dart';

abstract class RoleApi {
  Future<List<Role>> getRoles();
  Future<Role> getRoleById(int id);
}

class RoleApiImpl implements RoleApi {
  final Dio client;

  RoleApiImpl({
    required this.client
  });

  String get readUrl => "http://localhost:8080/userreadservice";

  @override
  Future<Role> getRoleById(int id) async {
    Response<Map<String, dynamic>> resp = await client.get("$readUrl/api/role", options: Options(extra: {'id': id}));
    if (resp.statusCode == 200) {
      return Role.fromMap(resp.data!);
    }
    else {
      return Role();
    }
  }

  @override
  Future<List<Role>> getRoles() async {
    Response<List<Map<String, dynamic>>> resp = await client.get("$readUrl/api/roles");
    if (resp.statusCode == 200) {
      return resp.data!.map((e) => Role.fromMap(e)).toList();
    }
    else {
      return List.empty();
    }
  }
}