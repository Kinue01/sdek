import 'package:clientapp/domain/model/Employee.dart';
import 'package:clientapp/domain/repository/current_employee_repository.dart';
import 'package:clientapp/local/local_storage/employee_local_storage.dart';

class CurrentEmployeeRepositoryImpl implements CurrentEmployeeRepository {
  final EmployeeLocalStorage employeeLocalStorage;

  CurrentEmployeeRepositoryImpl({
    required this.employeeLocalStorage
  });

  @override
  Future<Employee> getCurrentEmployee() async {
    return await employeeLocalStorage.getCurrentEmployee();
  }

  @override
  Future<void> saveCurrentEmployee(Employee emp) async {
    await employeeLocalStorage.saveCurrentEmployee(emp);
  }
}