import 'package:clientapp/data/repository/role_data_repository.dart';
import 'package:clientapp/domain/model/Role.dart';
import 'package:clientapp/domain/repository/role_repository.dart';

class RoleRepositoryImpl implements RoleRepository {
  RoleDataRepository repository;

  RoleRepositoryImpl({
    required this.repository
  });

  @override
  Future<Role> getRoleById(int id) async {
    return await repository.getRoleById(id);
  }

  @override
  Future<List<Role>> getRoles() async {
    return await repository.getRoles();
  }
}