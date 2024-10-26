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
    //User res = await controller.logIn();
    FluroApp.router.navigateTo(context, "/home");
  }

  @override
  Widget build(BuildContext context) {
    String login = watchX((LoginPageController controller) => controller.login);
    String pass = watchX((LoginPageController controller) => controller.password);

    return Scaffold(
      body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        login = text;
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
                      onChanged: (text) {
                        pass = text;
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
          )
    );
  }
}