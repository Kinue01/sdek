import 'package:clientapp/domain/model/Employee.dart';
import 'package:clientapp/domain/model/Position.dart';
import 'package:clientapp/domain/usecase/employee/AddEmployeeUseCase.dart';
import 'package:clientapp/domain/usecase/employee/GetEmployeesUseCase.dart';
import 'package:clientapp/domain/usecase/position/GetPositionsUseCase.dart';
import 'package:flutter/cupertino.dart';

class EmployeesPageContoller {
  final emps = ValueNotifier(<Employee>[]);
  final poses = ValueNotifier(<Position>[]);

  final GetEmployeesUseCase getEmployeesUseCase;
  final GetPositionsUseCase getPositionsUseCase;
  final AddEmployeeUseCase addEmployeeUseCase;
  EmployeesPageContoller({
    required this.getEmployeesUseCase,
    required this.getPositionsUseCase,
    required this.addEmployeeUseCase
  });

  Future<void> initEmps() async {
    emps.value = await getEmployeesUseCase.exec();
    poses.value = await getPositionsUseCase.exec();
  }

  Future<void> addEmp(Employee emp) async {
    await addEmployeeUseCase.exec(emp);
    await initEmps();
  }
}