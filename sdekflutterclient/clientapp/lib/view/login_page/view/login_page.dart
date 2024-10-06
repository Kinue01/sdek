import 'package:clientapp/view/login_page/controller/login_page_controller.dart';
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
  final _loginController = TextEditingController();
  final _passController = TextEditingController();

  _changeLogin() {
    get<LoginPageController>().login = _loginController.text;
  }

  _changePass() {
    get<LoginPageController>().password = _passController.text;
  }

  @override
  void initState() {
    super.initState();
    _loginController.addListener(_changeLogin);
    _passController.addListener(_changePass);
  }

  @override
  void dispose() {
    super.dispose();
    _loginController.dispose();
    _passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Login'
                ),
                controller: _loginController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextFormField(
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Password'
                ),
                controller: _passController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                  onPressed: get<LoginPageController>().logIn,
                  child: const Text('Войти')
              )
            ),
          ],
        )
      ),
    );
  }
}