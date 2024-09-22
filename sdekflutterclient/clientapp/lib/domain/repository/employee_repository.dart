import 'package:clientapp/domain/model/Employee.dart';
import 'package:uuid/uuid.dart';

abstract class EmployeeRepository {
  Future<List<Employee>> getEmployees();
  Future<Employee> getEmployeeById(Uuid uuid);
  Future<Employee> getEmployeeByUserId(Uuid uuid);
  Future<bool> addEmployee(Employee emp);
  Future<bool> updateEmplpoyee(Employee emp);
  Future<bool> deleteEmployee(Employee emp);
}