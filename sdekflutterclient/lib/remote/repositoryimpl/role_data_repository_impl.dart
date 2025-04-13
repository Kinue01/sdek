import 'package:clientapp/data/repository/role_data_repository.dart';
import 'package:clientapp/domain/model/Role.dart';
import 'package:clientapp/remote/api/role_api.dart';

class RoleDataRepositoryImpl implements RoleDataRepository {
  RoleApi roleApi;

  RoleDataRepositoryImpl({
    required this.roleApi
  });

  @override
  Future<Role> getRoleById(int id) async {
    return await roleApi.getRoleById(id);
  }

  @override
  Future<List<Role>> getRoles() async {
    return await roleApi.getRoles();
  }
}