import 'package:clientapp/view/account_page/account_page.dart';
import 'package:clientapp/view/employees_page/employees_page.dart';
import 'package:clientapp/view/home_page/view/home_view.dart';
import 'package:clientapp/view/main_page/main_page_controller.dart';
import 'package:clientapp/view/packages_page/packages_page.dart';
import 'package:clientapp/view/send_package_page/page/send_package_page.dart';
import 'package:clientapp/view/track_package_page/page/track_package_page.dart';
import 'package:clientapp/view/warehouses_page/warehouses_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainComponent();
  }

}

class MainComponent extends StatefulWidget with GetItStatefulWidgetMixin {
  @override
  State<StatefulWidget> createState() {
    return MainState();
  }
}

class MainState extends State<MainComponent> with GetItStateMixin {
  late MainPageController _controller;
  int _index = 0;

  late List<Widget> _views;
  late List<BottomNavigationBarItem> _bottomItems;

  @override
  void initState() {
    super.initState();
    _controller = get();
    ini();
  }

  void ini() {
    Future.delayed(Duration.zero, () async {
      await _controller.getCurrentUser();

      if (_controller.currentUser.user_role.role_id == 1) {
        await _controller.getCurrentClient();
      } else {
        await _controller.getCurrentEmployee();
      }

      if (_controller.currentUser.user_role.role_id == 2 && _controller.currentEmployee.employee_position.position_id == 1) {
        _views = [
          const PackagesPage(),
          const EmployeesPage(),
          const SendPackagePage(),
          const TrackPackagePage(),
          const AccountPage()
        ];
        _bottomItems = [
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Посылки'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Сотрудники'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.send),
              label: 'Оформить'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.track_changes),
              label: 'Отследить'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Аккаунт'
          )
        ];
      }

      if (_controller.currentUser.user_role.role_id == 2 && _controller.currentEmployee.employee_position.position_id != 1) {
        _views = [
          const PackagesPage(),
          const EmployeesPage(),
          const WarehousePage(),
          const TrackPackagePage(),
          const AccountPage()
        ];
        _bottomItems = [
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Посылки'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Сотрудники'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.warehouse),
              label: 'Склады'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.track_changes),
              label: 'Отследить'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Аккаунт'
          )
        ];
      }

      if (_controller.currentUser.user_role.role_id == 1) {
        _views = [
          const HomePage(),
          const TrackPackagePage(),
          const AccountPage()
        ];
        _bottomItems = [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Дом'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.track_changes),
              label: 'Отследить'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Аккаунт'
          )
        ];
      }
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _views[_index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _index,
        onTap: (int index) => {
          setState(() {
            _index = index;
          })
        },
        items: _bottomItems
      ),
    );
  } 
}