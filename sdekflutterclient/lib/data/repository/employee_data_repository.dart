import 'package:clientapp/domain/model/Employee.dart';

abstract class EmployeeDataRepository {
  Future<List<Employee>> getEmployees();
  Future<Employee> getEmployeeById(String uuid);
  Future<Employee> getEmployeeByUserId(String uuid);
  Future<bool> addEmployee(Employee emp);
  Future<bool> updateEmplpoyee(Employee emp);
  Future<bool> deleteEmployee(Employee emp);
}