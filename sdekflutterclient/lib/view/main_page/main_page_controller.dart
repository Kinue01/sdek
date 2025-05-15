import 'package:clientapp/domain/model/Client.dart';
import 'package:clientapp/domain/model/User.dart';
import 'package:clientapp/domain/usecase/client/GetCurrentClientUseCase.dart';
import 'package:clientapp/domain/usecase/employee/GetCurrentEmployeeUseCase.dart';
import 'package:clientapp/domain/usecase/user/GetCurrentUserUseCase.dart';

import '../../domain/model/Employee.dart';

class MainPageController {
  late User currentUser;
  late Client currentClient;
  late Employee currentEmployee;

  final GetCurrentUserUseCase getCurrentUserUseCase;
  final GetCurrentClientUseCase getCurrentClientUseCase;
  final GetCurrentEmployeeUseCase getCurrentEmployeeUseCase;
  MainPageController({
    required this.getCurrentUserUseCase,
    required this.getCurrentClientUseCase,
    required this.getCurrentEmployeeUseCase
  });

  Future<void> getCurrentUser() async {
    currentUser = await getCurrentUserUseCase.exec();
  }

  Future<void> getCurrentClient() async {
    currentClient = await getCurrentClientUseCase.exec();
  }

  Future<void> getCurrentEmployee() async {
    currentEmployee = await getCurrentEmployeeUseCase.getCurrentEmployee();
  }
}