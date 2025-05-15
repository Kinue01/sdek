import 'package:clientapp/domain/model/Employee.dart';

abstract class CurrentEmployeeRepository {
  Future<Employee> getCurrentEmployee();
  Future<void> saveCurrentEmployee(Employee emp);
}