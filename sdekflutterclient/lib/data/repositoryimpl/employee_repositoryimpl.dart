import 'package:clientapp/data/repository/employee_data_repository.dart';
import 'package:clientapp/domain/model/Employee.dart';
import 'package:clientapp/domain/model/Position.dart';
import 'package:clientapp/domain/model/Role.dart';
import 'package:clientapp/domain/model/User.dart';
import 'package:clientapp/domain/repository/employee_repository.dart';
import 'package:clientapp/local/local_storage/employee_local_storage.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  EmployeeDataRepository repository;
  EmployeeLocalStorage employeeLocalStorage;

  EmployeeRepositoryImpl({
    required this.repository,
    required this.employeeLocalStorage
  });

  @override
  Future<bool> addEmployee(Employee emp) async {
    if (await repository.addEmployee(emp)) {
      //await employeeLocalStorage.saveEmployee(emp);
      return true;
    }
    else {
      return false;
    }
  }

  @override
  Future<bool> deleteEmployee(Employee emp) async {
    if (await repository.deleteEmployee(emp)) {
      //await employeeLocalStorage.saveEmployee(Employee(employee_position: Position(), employee_user: User(user_role: Role())));
      return true;
    }
    else {
      return false;
    }
  }

  @override
  Future<Employee> getEmployeeById(String uuid) async {
    // final emp = await employeeLocalStorage.getEmployee(uuid);
    // if (emp.employee_id != "") {
    //   return emp;
    // }
    // else {
    //   final res = await repository.getEmployeeById(uuid);
    //   if (res.employee_id != "") {
    //     await employeeLocalStorage.saveEmployee(res);
    //   }
    //   return res;
    // }
    return await repository.getEmployeeById(uuid);
  }

  @override
  Future<Employee> getEmployeeByUserId(String uuid) async {
    // final emp = await employeeLocalStorage.getEmployeeByUser(uuid);
    // if (emp.employee_id != "") {
    //   return emp;
    // }
    // else {
    //   final res = await repository.getEmployeeByUserId(uuid);
    //   if (res.employee_id != "") {
    //     await employeeLocalStorage.saveEmployeeByUser(res);
    //   }
    //   return res;
    // }
    return await repository.getEmployeeByUserId(uuid);
  }

  @override
  Future<List<Employee>> getEmployees() async {
    // final emps = await employeeLocalStorage.getEmployees();
    // if (emps != []) {
    //   return emps;
    // }
    // else {
    //   final res = await repository.getEmployees();
    //   if (res != List.empty()) {
    //     await employeeLocalStorage.saveEmployees(res);
    //   }
    //   return res;
    // }
    return await repository.getEmployees();
  }

  @override
  Future<bool> updateEmplpoyee(Employee emp) async {
    if (await repository.updateEmplpoyee(emp)) {
      //await employeeLocalStorage.saveEmployee(emp);
      return true;
    }
    else {
      return false;
    }
  }
}