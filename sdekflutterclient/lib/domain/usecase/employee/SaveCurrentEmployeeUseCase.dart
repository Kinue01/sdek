import 'package:clientapp/domain/model/Employee.dart';
import 'package:clientapp/domain/repository/current_employee_repository.dart';

class SaveCurrentEmployeeUseCase {
  final CurrentEmployeeRepository repository;
  
  SaveCurrentEmployeeUseCase({
    required this.repository
  });
  
  Future<void> saveCurrentEmployee(Employee emp) async {
    await repository.saveCurrentEmployee(emp);
  }
}