import 'package:clientapp/domain/model/Position.dart';
import 'package:clientapp/domain/model/Role.dart';
import 'package:clientapp/domain/model/User.dart';
import 'package:dio/dio.dart';
import '../../domain/model/Employee.dart';

abstract class EmployeeApi {
  Future<List<Employee>> getEmployees();
  Future<Employee> getEmployeeById(String uuid);
  Future<Employee> getEmployeeByUserId(String uuid);
  Future<bool> addEmployee(Employee emp);
  Future<bool> updateEmplpoyee(Employee emp);
  Future<bool> deleteEmployee(Employee emp);
}

class EmployeeApiImpl implements EmployeeApi {
  final Dio client;
  
  EmployeeApiImpl({
    required this.client
  });
  
  String get url => "http://localhost:8080/employeeservice";
  String get readUrl => "http://localhost:8080/employeereadservice";
  
  @override
  Future<bool> addEmployee(Employee emp) async {
    Response response = await client.post("$url/api/employee", data: emp.toRawJson());
    switch (response.statusCode) {
      case 201:
        return true;
      default:
        return false;
    }
  }

  @override
  Future<bool> deleteEmployee(Employee emp) async {
    Response response = await client.delete("$url/api/employee", data: emp.toRawJson());
    switch (response.statusCode) {
      case 200:
        return true;
      default:
        return false;
    }
  }

  @override
  Future<Employee> getEmployeeById(String uuid) async {
    Response<Map<String, dynamic>> response = await client.get("$readUrl/api/employee", options: Options(extra: {'uuid': uuid}));
    switch (response.statusCode) {
      case 200:
        return Employee.fromMap(response.data!);
      default:
        return Employee(employee_position: Position(), employee_user: User(user_role: Role()));
    }
  }

  @override
  Future<Employee> getEmployeeByUserId(String uuid) async {
    Response<Map<String, dynamic>> response = await client.get("$readUrl/api/employee_user", options: Options(extra: {'uuid': uuid}));
    switch (response.statusCode) {
      case 200:
        return Employee.fromMap(response.data!);
      default:
        return Employee(employee_position: Position(), employee_user: User(user_role: Role()));
    }
  }

  @override
  Future<List<Employee>> getEmployees() async {
    Response<List<Map<String, dynamic>>> response = await client.get("$readUrl/api/employees");
    switch (response.statusCode) {
      case 200:
        return response.data!.map((e) => Employee.fromMap(e)).toList();
      default:
        return List.empty();
    }
  }

  @override
  Future<bool> updateEmplpoyee(Employee emp) async {
    Response response = await client.patch("$url/api/employee", data: emp.toRawJson());
    switch (response.statusCode) {
      case 200:
        return true;
      default:
        return false;
    }
  }
}