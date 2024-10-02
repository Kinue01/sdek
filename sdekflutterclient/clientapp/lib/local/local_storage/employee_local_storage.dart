import 'dart:math';

import 'package:clientapp/domain/model/Employee.dart';
import 'package:clientapp/domain/model/Position.dart';
import 'package:clientapp/domain/model/Role.dart';
import 'package:clientapp/domain/model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class EmployeeLocalStorage {
  Future<bool> saveEmployee(Employee emp);
  Future<bool> saveEmployees(List<Employee> emps);
  Future<List<Employee>> getEmployees();
  Future<Employee> getEmployee(String uuid);
  Future<bool> saveEmployeeByUser(Employee emp);
  Future<Employee> getEmployeeByUser(String uuid);
}

class EmployeeLocalStorageImpl implements EmployeeLocalStorage {
  final SharedPreferencesAsync sharedPreferencesAsync;

  EmployeeLocalStorageImpl({
    required this.sharedPreferencesAsync
  });

  @override
  Future<Employee> getEmployee(String uuid) async {
    final emp = await sharedPreferencesAsync.getString("EMP_$uuid");
    return emp != null ? Employee.fromRawJson(emp) : Employee(employee_position: Position(), employee_user: User(user_role: Role()));
  }

  @override
  Future<List<Employee>> getEmployees() async {
    final emps = await sharedPreferencesAsync.getStringList("EMPS");
    return emps != null ? emps.map((e) => Employee.fromRawJson(e)).toList() : [];
  }

  @override
  Future<bool> saveEmployee(Employee emp) async {
    final key = emp.employee_id;
    final json = emp.toRawJson();
    await sharedPreferencesAsync.setString("EMP_$key", json);
    return true;
  }

  @override
  Future<bool> saveEmployees(List<Employee> emps) async {
    await sharedPreferencesAsync.setStringList("EMPS", emps.map((e) => e.toRawJson()).toList());
    return true;
  }

  @override
  Future<Employee> getEmployeeByUser(String uuid) async {
    final emp = await sharedPreferencesAsync.getString("EMP_USER_$uuid");
    return emp != null ? Employee.fromRawJson(emp) : Employee(employee_position: Position(), employee_user: User(user_role: Role()));
  }

  @override
  Future<bool> saveEmployeeByUser(Employee emp) async {
    final key = emp.employee_user.user_id;
    final json = emp.toRawJson();
    await sharedPreferencesAsync.setString("EMP_USER_$key", json);
    return true;
  }
}