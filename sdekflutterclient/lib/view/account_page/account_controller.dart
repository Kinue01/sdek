import 'package:clientapp/domain/model/Role.dart';
import 'package:clientapp/domain/model/User.dart';
import 'package:clientapp/domain/usecase/client/GetCurrentClientUseCase.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/model/Client.dart';

class AccountController {
  ValueNotifier<Client?> client = ValueNotifier(Client(client_user: User(user_role: Role())));

  final GetCurrentClientUseCase getCurrentClientUseCase;

  AccountController({
    required this.getCurrentClientUseCase
  });

  Future<void> init() async {
    client.value = await getCurrentClientUseCase.exec();
  }
}