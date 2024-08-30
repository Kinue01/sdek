import 'package:clientapp/domain/model/Role.dart';
import 'package:clientapp/domain/repository/role_repository.dart';

class GetRolesUseCase {
  RoleRepository repository;

  GetRolesUseCase({
    required this.repository
  });

  Future<List<Role>> exec() async {
    return await repository.getRoles();
  }
}