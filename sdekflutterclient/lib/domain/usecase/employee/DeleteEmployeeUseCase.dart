import 'package:clientapp/domain/model/Employee.dart';
import 'package:clientapp/domain/repository/employee_repository.dart';

class DeleteEmployeeUseCase {
  EmployeeRepository repository;

  DeleteEmployeeUseCase({
    required this.repository
  });

  Future<bool> exec(Employee emp) async {
    return await repository.deleteEmployee(emp);
  }
}