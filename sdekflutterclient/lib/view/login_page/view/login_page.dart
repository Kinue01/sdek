import 'package:clientapp/domain/model/User.dart';
import 'package:clientapp/view/login_page/controller/login_page_controller.dart';
import 'package:clientapp/view/navigation_service/FluroApp.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginComponent();
  }
}

class LoginComponent extends StatefulWidget with GetItStatefulWidgetMixin {
  LoginComponent({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginViewState();
  }
}

class LoginViewState extends State<LoginComponent> with GetItStateMixin {
  late LoginPageController controller;

  @override
  void initState() {
    super.initState();
    controller = get<LoginPageController>();
  }

  void onLogin() async {
    if (controller.login.value == '' || controller.password.value == '') {
      showAdaptiveDialog(context: context, builder: (builder) => const AlertDialog(
        title: Text('Ошибка'),
        content: Text('Введите логин или пароль'),
      ));
      return;
    }

    User res = await controller.logIn();
    if (res.user_id == null) {
      showAdaptiveDialog(context: context, builder: (builder) => const AlertDialog(
        title: Text('Ошибка'),
        content: Text('Нет такого пользователя'),
      ));
      return;
    }

    await controller.saveUser(res);
    await controller.saveClient();
    FluroApp.router.navigateTo(context, "/home");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вход'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/images/logo.png", width: 400, height: 400,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 300,
                    child: TextField(
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Логин'
                      ),
                      onChanged: (text) {
                        controller.login.value = text;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Пароль'
                      ),
                      obscureText: true,
                      onChanged: (text) {
                        controller.password.value = text;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: onLogin,
                    child: const Text('Войти')
                  ),
                ],
              ),
            ],
          ),
      )
    );
  }
}