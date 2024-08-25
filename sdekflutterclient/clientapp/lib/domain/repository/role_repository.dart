import 'package:clientapp/domain/model/Role.dart';

abstract class RoleRepository {
  Future<List<Role>> getRoles();
  Future<Role> getRoleById(int id);
}