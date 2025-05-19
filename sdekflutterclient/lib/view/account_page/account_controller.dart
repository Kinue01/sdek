import 'package:clientapp/domain/model/Employee.dart';
import 'package:clientapp/domain/model/Position.dart';
import 'package:clientapp/domain/model/Role.dart';
import 'package:clientapp/domain/model/User.dart';
import 'package:clientapp/domain/usecase/client/GetCurrentClientUseCase.dart';
import 'package:clientapp/domain/usecase/employee/GetCurrentEmployeeUseCase.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/model/Client.dart';

class AccountController {
  final client = ValueNotifier(Client(client_user: User(user_role: Role())));
  final employee = ValueNotifier(Employee(employee_position: Position(), employee_user: User(user_role: Role())));

  final GetCurrentClientUseCase getCurrentClientUseCase;
  final GetCurrentEmployeeUseCase getCurrentEmployeeUseCase;

  AccountController({
    required this.getCurrentClientUseCase,
    required this.getCurrentEmployeeUseCase
  });

  Future<void> init() async {
    client.value = await getCurrentClientUseCase.exec();
    employee.value = await getCurrentEmployeeUseCase.getCurrentEmployee();
  }
}