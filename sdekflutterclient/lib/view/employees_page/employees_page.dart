import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:clientapp/domain/model/DeliveryPerson.dart';
import 'package:clientapp/domain/model/Employee.dart';
import 'package:clientapp/domain/model/Position.dart';
import 'package:clientapp/domain/model/Role.dart';
import 'package:clientapp/domain/model/Transport.dart';
import 'package:clientapp/domain/model/TransportStatus.dart';
import 'package:clientapp/domain/model/TransportType.dart';
import 'package:clientapp/domain/model/User.dart';
import 'package:clientapp/view/employees_page/employees_page_controller.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class EmployeesPage extends StatelessWidget {
  const EmployeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return EmployeesComponent();
  }
}

class EmployeesComponent extends StatefulWidget with GetItStatefulWidgetMixin {
  @override
  State<StatefulWidget> createState() {
    return EmployeesState();
  }
}

class EmployeesState extends State<EmployeesComponent> with GetItStateMixin {
  late EmployeesPageContoller _contoller;
  late TextEditingController _lastNameController;
  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _loginController;
  late TextEditingController _passController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _transNameController;
  late TextEditingController _transNumberController;

  late Employee selectedEmp = Employee(employee_position: Position(), employee_user: User(user_role: Role()));

  @override
  void initState() {
    super.initState();
    _contoller = get();
    _phoneController = TextEditingController();
    _lastNameController = TextEditingController();
    _firstNameController = TextEditingController();
    _middleNameController = TextEditingController();
    _loginController = TextEditingController();
    _passController = TextEditingController();
    _emailController = TextEditingController();
    _transNameController = TextEditingController();
    _transNumberController = TextEditingController();
    Future.delayed(Duration.zero, () async => await _contoller.initEmps());
  }

  @override
  Widget build(BuildContext context) {
    final list = watchX((EmployeesPageContoller c) => c.emps);
    final poses = watchX((EmployeesPageContoller c) => c.poses);
    final transTypes = watchX((EmployeesPageContoller c) => c.transTypes);

    return Scaffold(
      appBar: AppBar(
        title: Text("Emps"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    selectedEmp = Employee(employee_position: Position(), employee_user: User(user_role: Role()));

                    _lastNameController.text = "";
                    _firstNameController.text = "";
                    _middleNameController.text = "";
                    _loginController.text = "";
                    _passController.text = "";
                    _phoneController.text = "";
                    _emailController.text = "";
                    _transNumberController.text = "";
                    _transNameController.text = "";

                    AwesomeDialog(
                      context: context,
                      animType: AnimType.scale,
                      dialogType: DialogType.question,
                      title: "Add emp",
                      desc: "Add new employee",
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                labelText: "Фамилия",
                                border: UnderlineInputBorder()
                              ),
                              controller: _lastNameController,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                  labelText: "Имя",
                                  border: UnderlineInputBorder()
                              ),
                              controller: _firstNameController,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                  labelText: "Отчество",
                                  border: UnderlineInputBorder()
                              ),
                              controller: _middleNameController,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                  labelText: "Логин",
                                  border: UnderlineInputBorder()
                              ),
                              controller: _loginController,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                  labelText: "Пароль",
                                  border: UnderlineInputBorder()
                              ),
                              controller: _passController,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                            ),
                            TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                    labelText: "Телефон",
                                    border: UnderlineInputBorder()
                                ),
                              maxLength: 12,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                  labelText: "Почта",
                                  border: UnderlineInputBorder()
                              ),
                              controller: _emailController,
                            ),
                            Text(
                                "Данная часть активируется при выборе должности доставщик",
                              textAlign: TextAlign.center,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextField(
                                  decoration: InputDecoration(
                                      labelText: "Название транспорта",
                                      border: UnderlineInputBorder()
                                  ),
                                  controller: _transNameController,
                                ),
                                TextField(
                                  decoration: InputDecoration(
                                      labelText: "Номер",
                                      border: UnderlineInputBorder()
                                  ),
                                  controller: _transNumberController,
                                ),
                                DropdownMenu(
                                    label: Text("Type"),
                                    onSelected: (TransportType? type) {
                                      selectedEmp.delivery_transport!.transport_type = type;
                                    },
                                    dropdownMenuEntries: transTypes.map<DropdownMenuEntry<TransportType>>((TransportType type) => DropdownMenuEntry(value: type, label: type.type_name!)).toList()
                                ),
                              ],
                            ),
                            DropdownMenu<Position>(
                              label: Text("Position"),
                                onSelected: (Position? pos) {
                                  selectedEmp.employee_position.position_id = pos?.position_id;
                                  selectedEmp.employee_position.position_name = pos?.position_name;
                                  selectedEmp.employee_position.position_base_pay = pos?.position_base_pay;
                                },
                                dropdownMenuEntries: poses.map<DropdownMenuEntry<Position>>((Position pos) => DropdownMenuEntry<Position>(value: pos, label: pos.position_name!)).toList()
                            )
                          ],
                        ),
                      ),
                      btnOkOnPress: () {
                        if (selectedEmp.employee_position.position_id == 4) {
                          User empUser = User(
                            user_id: "",
                              user_login: _loginController.text,
                              user_email: _emailController.text,
                              user_phone: _phoneController.text,
                              user_access_token: "",
                              user_password: _passController.text,
                              user_role: Role(
                                role_id: 2,
                                role_name: "Сотрудник"
                              )
                          );

                          Transport trans = Transport(
                              transport_id: 0,
                              transport_name: _transNameController.text,
                            transport_reg_number: _transNumberController.text,
                            transport_type: selectedEmp.delivery_transport!.transport_type,
                            transport_status: TransportStatus(status_id: 1, status_name: "Ожидает")
                          );

                          DeliveryPerson person = DeliveryPerson(
                            person_id: 0,
                            person_transport: trans,
                            person_user: empUser,
                            person_firstname: _firstNameController.text,
                            person_lastname: _lastNameController.text,
                            person_middlename: _middleNameController.text
                          );

                          _contoller.addDelivery(person);
                          return;
                        }

                        User empUser = User(
                            user_id: "",
                            user_login: _loginController.text,
                            user_email: _emailController.text,
                            user_phone: _phoneController.text,
                            user_access_token: "",
                            user_password: _passController.text,
                            user_role: Role(
                                role_id: 2,
                                role_name: "Сотрудник"
                            )
                        );

                        selectedEmp.employee_lastname = _lastNameController.text;
                        selectedEmp.employee_firstname = _firstNameController.text;
                        selectedEmp.employee_middlename = _middleNameController.text;
                        selectedEmp.employee_user = empUser;

                        _contoller.addEmp(selectedEmp);
                      },
                    ).show();
                  },
                  child: Text("Add")
              ),
              TextButton(
                  onPressed: () async {
                    if (selectedEmp.employee_id == null) {
                      AwesomeDialog(
                        context: context,
                        title: "Not selected",
                        desc: "Employee not selected",
                        dialogType: DialogType.error,
                      ).show();
                      return;
                    }

                    _lastNameController.text = selectedEmp.employee_lastname!;
                    _firstNameController.text = selectedEmp.employee_firstname!;
                    _middleNameController.text = selectedEmp.employee_middlename!;
                    _loginController.text = selectedEmp.employee_user.user_login!;
                    _passController.text = selectedEmp.employee_user.user_password!;
                    _phoneController.text = selectedEmp.employee_user.user_phone!;
                    _emailController.text = selectedEmp.employee_user.user_email!;

                    if (selectedEmp.employee_position.position_id == 4) {
                      _transNumberController.text = selectedEmp.delivery_transport!.transport_reg_number!;
                      _transNameController.text = selectedEmp.delivery_transport!.transport_name!;
                    }

                    AwesomeDialog(
                      context: context,
                      animType: AnimType.scale,
                      dialogType: DialogType.question,
                      title: "Update emp",
                      desc: "Update existing employee",
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                  labelText: "Фамилия",
                                  border: UnderlineInputBorder()
                              ),
                              controller: _lastNameController,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                  labelText: "Имя",
                                  border: UnderlineInputBorder()
                              ),
                              controller: _firstNameController,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                  labelText: "Отчество",
                                  border: UnderlineInputBorder()
                              ),
                              controller: _middleNameController,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                  labelText: "Логин",
                                  border: UnderlineInputBorder()
                              ),
                              controller: _loginController,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                  labelText: "Пароль",
                                  border: UnderlineInputBorder()
                              ),
                              controller: _passController,
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                            ),
                            TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  labelText: "Телефон",
                                  border: UnderlineInputBorder()
                              ),
                              maxLength: 12,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                  labelText: "Почта",
                                  border: UnderlineInputBorder()
                              ),
                              controller: _emailController,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextField(
                                  decoration: InputDecoration(
                                      labelText: "Название транспорта",
                                      border: UnderlineInputBorder()
                                  ),
                                  controller: _transNameController,
                                ),
                                TextField(
                                  decoration: InputDecoration(
                                      labelText: "Номер",
                                      border: UnderlineInputBorder()
                                  ),
                                  controller: _transNumberController,
                                ),
                                DropdownMenu<TransportType>(
                                    label: Text("Type"),
                                    initialSelection: selectedEmp.delivery_transport!.transport_type,
                                    onSelected: (TransportType? type) {
                                      selectedEmp.delivery_transport!.transport_type = type;
                                    },
                                    dropdownMenuEntries: transTypes.map<DropdownMenuEntry<TransportType>>((TransportType type) => DropdownMenuEntry(value: type, label: type.type_name!)).toList()
                                ),
                              ],
                            ),
                            DropdownMenu<Position>(
                                label: Text("Position"),
                                initialSelection: selectedEmp.employee_position,
                                onSelected: (Position? pos) {
                                  selectedEmp.employee_position.position_id = pos?.position_id;
                                  selectedEmp.employee_position.position_name = pos?.position_name;
                                  selectedEmp.employee_position.position_base_pay = pos?.position_base_pay;
                                },
                                dropdownMenuEntries: poses.map<DropdownMenuEntry<Position>>((Position pos) => DropdownMenuEntry<Position>(value: pos, label: pos.position_name!)).toList()
                            )
                          ],
                        ),
                      ),
                      btnOkOnPress: () {
                        if (selectedEmp.employee_position.position_id == 4) {
                          User empUser = User(
                              user_id: selectedEmp.employee_user.user_id,
                              user_login: _loginController.text,
                              user_email: _emailController.text,
                              user_phone: _phoneController.text,
                              user_access_token: "",
                              user_password: _passController.text,
                              user_role: selectedEmp.employee_user.user_role
                          );

                          Transport trans = Transport(
                              transport_id: selectedEmp.delivery_transport!.transport_id,
                              transport_name: _transNameController.text,
                              transport_reg_number: _transNumberController.text,
                              transport_type: selectedEmp.delivery_transport!.transport_type,
                              transport_status: selectedEmp.delivery_transport!.transport_status
                          );

                          DeliveryPerson person = DeliveryPerson(
                              person_id: int.tryParse(selectedEmp.employee_id!),
                              person_transport: trans,
                              person_user: empUser,
                              person_firstname: _firstNameController.text,
                              person_lastname: _lastNameController.text,
                              person_middlename: _middleNameController.text
                          );

                          _contoller.updateDelivery(person);
                          return;
                        }

                        User empUser = User(
                          user_login: _loginController.text,
                            user_password: _passController.text,
                            user_phone: _phoneController.text,
                            user_email: _emailController.text,
                            user_id: selectedEmp.employee_user.user_id,
                            user_access_token: "",
                            user_role: selectedEmp.employee_user.user_role
                        );

                        selectedEmp.employee_lastname = _lastNameController.text;
                        selectedEmp.employee_firstname = _firstNameController.text;
                        selectedEmp.employee_middlename = _middleNameController.text;
                        selectedEmp.employee_user = empUser;

                        _contoller.updateEmp(selectedEmp);
                      },
                    ).show();
                  },
                  child: Text("Update")
              ),
              TextButton(
                  onPressed: () {
                    if (selectedEmp.employee_id == null) {
                      AwesomeDialog(
                        context: context,
                        title: "Not selected",
                        desc: "Employee not selected",
                        dialogType: DialogType.error,
                      ).show();
                      return;
                    }

                    AwesomeDialog(
                      context: context,
                      animType: AnimType.scale,
                      dialogType: DialogType.question,
                      title: "Delete emp",
                      desc: "Delete employee",
                      body: Center(
                        child: Text("Вы уверены, что хотите удалить сотрудника ${selectedEmp.employee_lastname} ${selectedEmp.employee_firstname} ${selectedEmp.employee_middlename}"),
                      ),
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {
                        if (selectedEmp.employee_position.position_id == 4) {
                          DeliveryPerson person = DeliveryPerson(
                            person_id: int.tryParse(selectedEmp.employee_id!),
                            person_lastname: selectedEmp.employee_lastname,
                            person_middlename: selectedEmp.employee_middlename,
                            person_user: selectedEmp.employee_user,
                            person_transport: selectedEmp.delivery_transport,
                            person_firstname: selectedEmp.employee_firstname
                          );
                          _contoller.deleteDelivery(person);
                        }

                        _contoller.deleteEmp(selectedEmp);
                      },
                    ).show();
                  },
                  child: Text("Delete")
              ),
            ],
          ),
          Expanded(
              child: DataTable2(
                  empty: Center(
                      child: Container(
                          padding: const EdgeInsets.all(20),
                          color: Colors.grey[200],
                          child: const Text('No data'))),
                  columns: [
                    DataColumn2(
                        label: Text("Lastname")
                    ),
                    DataColumn2(
                        label: Text("Firstname")
                    ),
                    DataColumn2(
                        label: Text("Middlename")
                    ),
                    DataColumn2(
                        label: Text("Position")
                    ),
                    DataColumn2(
                        label: Text("Phone")
                    ),
                    DataColumn2(
                        label: Text("Email")
                    ),
                    DataColumn2(
                        label: Text("Transport (if exists)")
                    ),
                  ],
                  rows: List<DataRow2>.generate(
                      list.length,
                          (index) => DataRow2(
                            onTap: () {
                              selectedEmp = list[index];
                            },
                          cells: [
                            DataCell(
                                Text(list[index].employee_lastname!)
                            ),
                            DataCell(
                                Text(list[index].employee_firstname!)
                            ),
                            DataCell(
                                Text(list[index].employee_middlename!)
                            ),
                            DataCell(
                                Text(list[index].employee_position.position_name!)
                            ),
                            DataCell(
                                Text(list[index].employee_user.user_phone!)
                            ),
                            DataCell(
                                Text(list[index].employee_user.user_email!)
                            ),
                            DataCell(
                                Text(list[index].delivery_transport != null ? list[index].delivery_transport!.transport_name! : "No transport")
                            ),
                          ]
                      )
                  )
              ),
          )
        ],
      )
    );
  }
}