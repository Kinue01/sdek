import 'package:clientapp/domain/model/Employee.dart';
import 'package:clientapp/domain/repository/current_employee_repository.dart';

class GetCurrentEmployeeUseCase {
  final CurrentEmployeeRepository repository;

  GetCurrentEmployeeUseCase({
    required this.repository
  });

  Future<Employee> getCurrentEmployee() async {
    return await repository.getCurrentEmployee();
  }
}