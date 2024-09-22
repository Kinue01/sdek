import 'package:clientapp/domain/model/Employee.dart';
import 'package:clientapp/domain/repository/employee_repository.dart';
import 'package:uuid/uuid.dart';

class GetEmployeeByUserIdUseCase {
  EmployeeRepository repository;

  GetEmployeeByUserIdUseCase({
    required this.repository
  });

  Future<Employee> exec(Uuid uuid) async {
    return await repository.getEmployeeByUserId(uuid);
  }
}