import 'package:clientapp/domain/model/Client.dart';
import 'package:clientapp/domain/model/Role.dart';
import 'package:clientapp/domain/model/User.dart';
import 'package:clientapp/view/account_page/account_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_it_mixin/get_it_mixin.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AccountComponent();
  }
}

class AccountComponent extends StatefulWidget with GetItStatefulWidgetMixin {
  AccountComponent({super.key});

  @override
  State<StatefulWidget> createState() {
    return AccountState();
  }
}

class AccountState extends State<AccountComponent> with GetItStateMixin {
  late AccountController? controller;
  Client? client;

  @override
  void dispose() {
    super.dispose();
    controller?.client.value = null;
    controller = null;
  }

  @override
  void initState() {
    super.initState();
    controller = get<AccountController>();
    Future.delayed(Duration.zero, () async {
      await get<AccountController>().init();
    });
    controller?.client.addListener(() {
      setState(() {
        client = controller!.client.value;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Аккаунт'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.asset("assets/images/acc.png", width: 200, height: 200),
                  Text("${client?.client_lastname} ${client?.client_firstname} ${client?.client_middlename}")
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("${client?.client_user.user_phone}"),
                  Text("${client?.client_user.user_email}"),
                  Text("${client?.client_user.user_role.role_name}")
                ],
              )
            ],
          ),
      ),
    );
  }
}