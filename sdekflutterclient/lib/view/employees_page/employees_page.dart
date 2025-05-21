import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:clientapp/domain/model/Employee.dart';
import 'package:clientapp/domain/model/Position.dart';
import 'package:clientapp/domain/model/Role.dart';
import 'package:clientapp/domain/model/User.dart';
import 'package:clientapp/view/employees_page/employees_page_controller.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

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
    Future.delayed(Duration.zero, () async => await _contoller.initEmps());
  }

  @override
  Widget build(BuildContext context) {
    var list = watchX((EmployeesPageContoller c) => c.emps);
    var poses = watchX((EmployeesPageContoller c) => c.poses);

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
                            InternationalPhoneNumberInput(
                                onInputChanged: (PhoneNumber num) async {
                                  PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber(num.parseNumber());
                                  String parsableNumber = number.parseNumber();
                                  _phoneController.text = parsableNumber;
                                },
                              // textFieldController: _phoneController,
                            ),
                            TextField(
                              decoration: InputDecoration(
                                  labelText: "Почта",
                                  border: UnderlineInputBorder()
                              ),
                              controller: _emailController,
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
                        User empUser = User(user_role: Role());
                        empUser.user_login = _loginController.text;
                        empUser.user_password = _passController.text;
                        empUser.user_email = _emailController.text;
                        empUser.user_phone = _phoneController.text;
                        empUser.user_role.role_id = 2;
                        empUser.user_role.role_name = "Сотрудник";

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
                  onPressed: () {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.scale,
                      dialogType: DialogType.info,
                      title: "Add emp",
                      desc: "Add new employee",
                      body: Center(
                        child: Column(

                        ),
                      ),
                      btnOkOnPress: () {

                      },
                    );
                  },
                  child: Text("Update")
              ),
              TextButton(
                  onPressed: () {
                    AwesomeDialog(
                      context: context,
                      animType: AnimType.scale,
                      dialogType: DialogType.info,
                      title: "Add emp",
                      desc: "Add new employee",
                      body: Center(
                        child: Column(

                        ),
                      ),
                      btnOkOnPress: () {

                      },
                    );
                  },
                  child: Text("Delete")
              ),
            ],
          ),
          Expanded(
              child: DataTable2(
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
                  ],
                  rows: List<DataRow2>.generate(
                      list.length,
                          (index) => DataRow2(
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