import 'package:clientapp/domain/model/Package.dart';
import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../domain/model/Client.dart';
import '../../../domain/model/Role.dart';
import '../../../domain/model/User.dart';
import '../../../domain/usecase/client/GetCurrentClientUseCase.dart';
import '../../../domain/usecase/pack/GetPackagesByClientIdUseCase.dart';

class TrackPackageController {
  final packages = ValueNotifier(<Package>[]);
  final client = ValueNotifier(Client(client_user: User(user_role: Role())));
  final GetPackagesByClientIdUseCase getPackagesByClientIdUseCase;
  final GetCurrentClientUseCase getCurrentClientUseCase;
  final channel = WebSocketChannel.connect(Uri.parse("ws://localhost:8080/transportreadservice/api/transport_pos"));

  TrackPackageController({
    required this.getPackagesByClientIdUseCase,
    required this.getCurrentClientUseCase
  });

  Future<void> getClientPackages() async {
    client.value = await getCurrentClientUseCase.exec();
    packages.value = await getPackagesByClientIdUseCase.exec(client.value.client_id!);
  }
}