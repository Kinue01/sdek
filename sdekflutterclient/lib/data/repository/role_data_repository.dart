import 'package:clientapp/domain/model/Role.dart';

abstract class RoleDataRepository {
  Future<List<Role>> getRoles();
  Future<Role> getRoleById(int id);
}