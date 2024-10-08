import 'package:clientapp/domain/model/Role.dart';
import 'package:clientapp/domain/model/User.dart';
import 'package:clientapp/domain/usecase/auth/GetUserByLoginPassUseCase.dart';
import 'package:flutter/material.dart';

class LoginPageController {
  var login = ValueNotifier("");
  var password = ValueNotifier("");
  final GetUserByLoginPassUseCase getUserByLoginPassUseCase;

  LoginPageController({
    required this.getUserByLoginPassUseCase
  });

  Future<User> logIn() async {
    return await getUserByLoginPassUseCase.exec(User(user_role: Role(), user_login: login.value, user_password: password.value));
  }
}