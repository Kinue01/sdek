import 'package:clientapp/domain/model/Employee.dart';
import 'package:clientapp/domain/repository/employee_repository.dart';

class AddEmployeeUseCase {
  EmployeeRepository repository;

  AddEmployeeUseCase({
    required this.repository
  });

  Future<bool> exec(Employee emp) async {
    return await repository.addEmployee(emp);
  }
}