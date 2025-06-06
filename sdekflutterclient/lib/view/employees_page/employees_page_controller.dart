import 'dart:io';

import 'package:clientapp/domain/model/DeliveryPerson.dart';
import 'package:clientapp/domain/model/Employee.dart';
import 'package:clientapp/domain/model/Position.dart';
import 'package:clientapp/domain/model/TransportType.dart';
import 'package:clientapp/domain/usecase/delivery_person/AddDeliveryPersonUseCase.dart';
import 'package:clientapp/domain/usecase/delivery_person/DeleteDeliveryPersonUseCase.dart';
import 'package:clientapp/domain/usecase/delivery_person/UpdateDeliveryPersonUseCase.dart';
import 'package:clientapp/domain/usecase/delivery_person/get_delivery_personal_use_case.dart';
import 'package:clientapp/domain/usecase/employee/AddEmployeeUseCase.dart';
import 'package:clientapp/domain/usecase/employee/DeleteEmployeeUseCase.dart';
import 'package:clientapp/domain/usecase/employee/GetEmployeesUseCase.dart';
import 'package:clientapp/domain/usecase/employee/UpdateEmployeeUseCase.dart';
import 'package:clientapp/domain/usecase/position/GetPositionsUseCase.dart';
import 'package:clientapp/domain/usecase/transport/AddTransportUseCase.dart';
import 'package:clientapp/domain/usecase/transport/DeleteTransportUseCase.dart';
import 'package:clientapp/domain/usecase/transport/UpdateTransportUseCase.dart';
import 'package:clientapp/domain/usecase/transport_type/GetTransportTypesUseCase.dart';
import 'package:clientapp/domain/usecase/transport_type/UpdateTransportTypeUseCase.dart';
import 'package:clientapp/domain/usecase/user/AddUserUseCase.dart';
import 'package:clientapp/domain/usecase/user/DeleteUserUseCase.dart';
import 'package:clientapp/domain/usecase/user/UpdateUserUseCase.dart';
import 'package:flutter/cupertino.dart';

class EmployeesPageContoller {
  final emps = ValueNotifier(<Employee>[]);
  final poses = ValueNotifier(<Position>[]);
  final transTypes = ValueNotifier(<TransportType>[]);

  final GetEmployeesUseCase getEmployeesUseCase;
  final GetPositionsUseCase getPositionsUseCase;
  final AddEmployeeUseCase addEmployeeUseCase;
  final UpdateEmployeeUseCase updateEmployeeUseCase;
  final DeleteEmployeeUseCase deleteEmployeeUseCase;
  final GetDeliveryPersonalUseCase getDeliveryPersonalUseCase;
  final AddDeliveryPersonUseCase addDeliveryPersonUseCase;
  final UpdateDeliveryPersonUseCase updateDeliveryPersonUseCase;
  final DeleteDeliveryPersonUseCase deleteDeliveryPersonUseCase;
  final GetTransportTypesUseCase getTransportTypesUseCase;
  final AddUserUseCase addUserUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final DeleteUserUseCase deleteUserUseCase;
  final AddTransportUseCase addTransportUseCase;
  final UpdateTransportUseCase updateTransportUseCase;
  final DeleteTransportUseCase deleteTransportUseCase;
  EmployeesPageContoller({
    required this.getEmployeesUseCase,
    required this.getPositionsUseCase,
    required this.addEmployeeUseCase,
    required this.updateEmployeeUseCase,
    required this.deleteEmployeeUseCase,
    required this.getDeliveryPersonalUseCase,
    required this.addDeliveryPersonUseCase,
    required this.updateDeliveryPersonUseCase,
    required this.deleteDeliveryPersonUseCase,
    required this.getTransportTypesUseCase,
    required this.addUserUseCase,
    required this.updateUserUseCase,
    required this.deleteUserUseCase,
    required this.addTransportUseCase,
    required this.updateTransportUseCase,
    required this.deleteTransportUseCase
  });

  Future<void> initEmps() async {
    var temp = await getEmployeesUseCase.exec();
    poses.value = await getPositionsUseCase.exec();
    transTypes.value = await getTransportTypesUseCase.exec();

    var delivery = await getDeliveryPersonalUseCase.exec();
    temp.addAll(delivery.map((d) => Employee(
      employee_id: d.person_id.toString(),
      employee_lastname: d.person_lastname,
        employee_firstname: d.person_firstname,
        employee_middlename: d.person_middlename,
        employee_position: Position(position_id: 4, position_name: "Доставщик", position_base_pay: 80000),
        employee_user: d.person_user!,
      delivery_transport: d.person_transport
    )).toList());

    emps.value = temp;

    poses.value.add(Position(position_id: 4, position_name: "Доставщик", position_base_pay: 80000));
  }

  Future<void> addEmp(Employee emp) async {
    await addEmployeeUseCase.exec(emp);
    await Future.delayed(Duration(seconds: 1));
    await initEmps();
  }

  Future<void> updateEmp(Employee emp) async {
    await updateEmployeeUseCase.exec(emp);
    await Future.delayed(Duration(seconds: 1));
    await initEmps();
  }

  Future<void> deleteEmp(Employee emp) async {
    await deleteEmployeeUseCase.exec(emp);
    await Future.delayed(Duration(seconds: 1));
    await initEmps();
  }

  Future<void> addDelivery(DeliveryPerson person) async {
    await addUserUseCase.exec(person.person_user!);
    await addTransportUseCase.exec(person.person_transport!);
    await Future.delayed(Duration(seconds: 3));
    await addDeliveryPersonUseCase.exec(person);
    await Future.delayed(Duration(seconds: 1));
    await initEmps();
  }

  Future<void> updateDelivery(DeliveryPerson person) async {
    await updateUserUseCase.exec(person.person_user!);
    await updateTransportUseCase.exec(person.person_transport!);
    await Future.delayed(Duration(seconds: 3));
    await updateDeliveryPersonUseCase.exec(person);
    await Future.delayed(Duration(seconds: 1));
    await initEmps();
  }

  Future<void> deleteDelivery(DeliveryPerson person) async {
    await deleteDeliveryPersonUseCase.exec(person);
    await Future.delayed(Duration(seconds: 3));
    await deleteTransportUseCase.exec(person.person_transport!);
    await deleteUserUseCase.exec(person.person_user!);
    await Future.delayed(Duration(seconds: 1));
    await initEmps();
  }
}