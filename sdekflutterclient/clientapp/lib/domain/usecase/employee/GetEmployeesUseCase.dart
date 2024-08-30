import 'package:clientapp/domain/model/Employee.dart';
import 'package:clientapp/domain/repository/employee_repository.dart';

class GetEmployeesUseCase {
  EmployeeRepository repository;

  GetEmployeesUseCase({
    required this.repository
  });

  Future<List<Employee>> exec() async {
    return await repository.getEmployees();
  }
}