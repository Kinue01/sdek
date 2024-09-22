import 'package:clientapp/data/repository/employee_data_repository.dart';
import 'package:clientapp/domain/model/Employee.dart';
import 'package:clientapp/domain/repository/employee_repository.dart';
import 'package:uuid/uuid.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  EmployeeDataRepository repository;

  EmployeeRepositoryImpl({
    required this.repository
  });

  @override
  Future<bool> addEmployee(Employee emp) async {
    return await repository.addEmployee(emp);
  }

  @override
  Future<bool> deleteEmployee(Employee emp) async {
    return await repository.deleteEmployee(emp);
  }

  @override
  Future<Employee> getEmployeeById(Uuid uuid) async {
    return await repository.getEmployeeById(uuid);
  }

  @override
  Future<Employee> getEmployeeByUserId(Uuid uuid) async {
    return await repository.getEmployeeByUserId(uuid);
  }

  @override
  Future<List<Employee>> getEmployees() async {
    return await repository.getEmployees();
  }

  @override
  Future<bool> updateEmplpoyee(Employee emp) async {
    return await repository.updateEmplpoyee(emp);
  }
}