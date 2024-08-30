import 'package:clientapp/domain/model/Role.dart';
import 'package:clientapp/domain/repository/role_repository.dart';

class GetRoleByIdUseCase {
  RoleRepository repository;

  GetRoleByIdUseCase({
    required this.repository
  });

  Future<Role> exec(int id) async {
    return await repository.getRoleById(id);
  }
}