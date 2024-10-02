import 'package:clientapp/data/repository/role_data_repository.dart';
import 'package:clientapp/domain/model/Role.dart';
import 'package:clientapp/domain/repository/role_repository.dart';
import 'package:clientapp/local/local_storage/role_local_storage.dart';

class RoleRepositoryImpl implements RoleRepository {
  RoleDataRepository repository;
  RoleLocalStorage roleLocalStorage;

  RoleRepositoryImpl({
    required this.repository,
    required this.roleLocalStorage
  });

  @override
  Future<Role> getRoleById(int id) async {
    final role = await roleLocalStorage.getRole(id);
    if (role.role_id != 0) {
      return role;
    }
    else {
      final res = await repository.getRoleById(id);
      if (res.role_id != 0) {
        await roleLocalStorage.saveRole(res);
      }
      return res;
    }
  }

  @override
  Future<List<Role>> getRoles() async {
    final roles = await roleLocalStorage.getRoles();
    if (roles != []) {
      return roles;
    }
    else {
      final res = await repository.getRoles();
      if (res != List.empty()) {
        await roleLocalStorage.saveRoles(res);
      }
      return res;
    }
  }
}