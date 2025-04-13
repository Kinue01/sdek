import 'package:clientapp/domain/model/Employee.dart';
import 'package:clientapp/domain/repository/employee_repository.dart';

class GetEmployeeByIdUseCase {
  EmployeeRepository repository;

  GetEmployeeByIdUseCase({
    required this.repository
  });

  Future<Employee> exec(String uuid) async {
    return await repository.getEmployeeById(uuid);
  }
}