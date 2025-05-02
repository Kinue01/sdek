import 'package:clientapp/domain/model/Role.dart';
import 'package:clientapp/domain/model/User.dart';
import 'package:clientapp/domain/usecase/role/GetRoleByIdUseCase.dart';
import 'package:clientapp/domain/usecase/user/AddUserUseCase.dart';

class RegisterController {
  final GetRoleByIdUseCase getRoleByIdUseCase;
  final AddUserUseCase addUserUseCase;

  RegisterController({
    required this.getRoleByIdUseCase,
    required this.addUserUseCase
  });

  Future<Role> getRole(int id) async {
    return await getRoleByIdUseCase.exec(id);
  }

  void addUser(User user) async {
    await addUserUseCase.exec(user);
  }
}