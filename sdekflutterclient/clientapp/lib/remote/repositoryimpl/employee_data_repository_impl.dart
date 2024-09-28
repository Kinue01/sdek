import 'package:clientapp/data/repository/employee_data_repository.dart';
import 'package:clientapp/domain/model/Employee.dart';
import 'package:clientapp/remote/api/employee_api.dart';

class EmployeeDataRepositoryImpl implements EmployeeDataRepository {
  EmployeeApi employeeApi;

  EmployeeDataRepositoryImpl({
    required this.employeeApi
  });

  @override
  Future<bool> addEmployee(Employee emp) async {
    return await employeeApi.addEmployee(emp);
  }

  @override
  Future<bool> deleteEmployee(Employee emp) async {
    return await employeeApi.deleteEmployee(emp);
  }

  @override
  Future<Employee> getEmployeeById(String uuid) async {
    return await employeeApi.getEmployeeById(uuid);
  }

  @override
  Future<Employee> getEmployeeByUserId(String uuid) async {
    return await employeeApi.getEmployeeByUserId(uuid);
  }

  @override
  Future<List<Employee>> getEmployees() async {
    return await employeeApi.getEmployees();
  }

  @override
  Future<bool> updateEmplpoyee(Employee emp) async {
    return await employeeApi.updateEmplpoyee(emp);
  }
}