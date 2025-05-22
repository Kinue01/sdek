import 'dart:async';
import 'dart:convert';

import 'package:clientapp/Env.dart';
import 'package:clientapp/domain/model/Package.dart';
import 'package:clientapp/domain/usecase/pack/GetPackagesUseCase.dart';
import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../domain/model/Client.dart';
import '../../../domain/model/Role.dart';
import '../../../domain/model/TransportPosition.dart';
import '../../../domain/model/User.dart';
import '../../../domain/usecase/client/GetCurrentClientUseCase.dart';
import '../../../domain/usecase/pack/GetPackagesByClientIdUseCase.dart';

class TrackPackageController {
  final packages = ValueNotifier(<Package>[]);
  final client = ValueNotifier(Client(client_user: User(user_role: Role())));
  final GetPackagesByClientIdUseCase getPackagesByClientIdUseCase;
  final GetCurrentClientUseCase getCurrentClientUseCase;
  final GetPackagesUseCase getPackagesUseCase;
  late final channel = WebSocketChannel.connect(Uri.parse("${Env.prod_ws}/transportreadservice/api/transport_pos"));

  late StreamController streamController = StreamController.broadcast();

  TrackPackageController({
    required this.getPackagesByClientIdUseCase,
    required this.getCurrentClientUseCase,
    required this.getPackagesUseCase
  }) {
    channel.stream.listen((ev) {
      final res = json.decode(ev).cast<dynamic>().toList();
      final poses = res.map((e) => TransportPosition.fromMap(e)).toList();
      var posesToShow = List<TransportPosition>.empty(growable: true);

      for (var p in poses) {
        for (var pack in packages.value) {
          if (pack.package_deliveryperson?.person_transport?.transport_id.toString() == p.transport_id && pack.package_status?.status_id == 2) {
            posesToShow.add(p);
          }
        }
      }

      streamController.add(posesToShow);
    });
  }

  Future<void> getClientPackages() async {
    client.value = await getCurrentClientUseCase.exec();

    print(client.value);

    if (client.value.client_id ==null) packages.value = await getPackagesUseCase.exec();
    else packages.value = await getPackagesByClientIdUseCase.exec(client.value.client_id!);
  }

  void init() {
    streamController = StreamController.broadcast();
  }

  void dispose() {
    streamController.close();
  }
}