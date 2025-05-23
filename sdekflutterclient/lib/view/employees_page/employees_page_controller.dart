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
import 'package:clientapp/domain/usecase/transport_type/GetTransportTypesUseCase.dart';
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
    required this.getTransportTypesUseCase
  });

  Future<void> initEmps() async {
    emps.value = await getEmployeesUseCase.exec();
    poses.value = await getPositionsUseCase.exec();
    transTypes.value = await getTransportTypesUseCase.exec();

    var delivery = await getDeliveryPersonalUseCase.exec();
    emps.value.addAll(delivery.map((d) => Employee(
      employee_id: d.person_id.toString(),
      employee_lastname: d.person_lastname,
        employee_firstname: d.person_firstname,
        employee_middlename: d.person_middlename,
        employee_position: Position(position_id: 4, position_name: "Доставщик", position_base_pay: 80000),
        employee_user: d.person_user!,
      delivery_transport: d.person_transport
    )).toList());

    poses.value.add(Position(position_id: 4, position_name: "Доставщик", position_base_pay: 80000));
  }

  Future<void> addEmp(Employee emp) async {
    await addEmployeeUseCase.exec(emp);
    await initEmps();
  }

  Future<void> updateEmp(Employee emp) async {
    await updateEmployeeUseCase.exec(emp);
    await initEmps();
  }

  Future<void> deleteEmp(Employee emp) async {
    await deleteEmployeeUseCase.exec(emp);
    await initEmps();
  }

  Future<void> addDelivery(DeliveryPerson person) async {
    await addDeliveryPersonUseCase.exec(person);
  }

  Future<void> updateDelivery(DeliveryPerson person) async {
    await updateDeliveryPersonUseCase.exec(person);
  }

  Future<void> deleteDelivery(DeliveryPerson person) async {
    await deleteDeliveryPersonUseCase.exec(person);
  }
}