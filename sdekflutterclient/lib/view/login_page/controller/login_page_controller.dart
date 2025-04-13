import 'package:clientapp/domain/model/Client.dart';
import 'package:clientapp/domain/model/Role.dart';
import 'package:clientapp/domain/model/User.dart';
import 'package:clientapp/domain/usecase/auth/GetUserByLoginPassUseCase.dart';
import 'package:clientapp/domain/usecase/client/GetClientByUserIdUseCase.dart';
import 'package:clientapp/domain/usecase/client/SaveCurrentClientUseCase.dart';
import 'package:clientapp/domain/usecase/user/GetCurrentUserUseCase.dart';
import 'package:clientapp/domain/usecase/user/SaveCurrentUserUseCase.dart';
import 'package:flutter/material.dart';

class LoginPageController {
  late User user;

  var login = ValueNotifier("");
  var password = ValueNotifier("");
  final GetUserByLoginPassUseCase getUserByLoginPassUseCase;
  final SaveCurrentUserUseCase saveCurrentUserUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final SaveCurrentClientUseCase saveCurrentClientUseCase;
  final GetClientByUserIdUseCase getClientByUserIdUseCase;

  LoginPageController({
    required this.getUserByLoginPassUseCase,
    required this.saveCurrentUserUseCase,
    required this.getCurrentUserUseCase,
    required this.saveCurrentClientUseCase,
    required this.getClientByUserIdUseCase
  });

  Future<User> logIn() async {
    user = await getUserByLoginPassUseCase.exec(User(user_role: Role(role_id: 0, role_name: ""), user_login: login.value, user_password: password.value, user_id: "", user_email: "", user_phone: "", user_access_token: ""));
    return user;
  }

  Future<bool> saveUser(User user) async {
    return await saveCurrentUserUseCase.exec(user);
  }

  Future<void> saveClient() async {
    Client client = await getClientByUserIdUseCase.exec(user.user_id!);
    saveCurrentClientUseCase.exec(client);
  }
}