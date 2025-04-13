import 'package:clientapp/domain/model/Client.dart';
import 'package:clientapp/domain/model/Employee.dart';
import 'package:clientapp/domain/model/Package.dart';
import 'package:clientapp/domain/model/PackageItem.dart';
import 'package:clientapp/domain/model/PackageStatus.dart';
import 'package:clientapp/domain/model/PackageType.dart';
import 'package:clientapp/domain/model/Position.dart';
import 'package:clientapp/domain/model/Role.dart';
import 'package:clientapp/domain/model/Transport.dart';
import 'package:clientapp/domain/model/TransportType.dart';
import 'package:clientapp/domain/model/User.dart';
import 'package:clientapp/domain/usecase/client/GetCurrentClientUseCase.dart';
import 'package:clientapp/domain/usecase/pack/GetPackagesByClientIdUseCase.dart';
import 'package:flutter/material.dart';

class ClientPackagesPageController {
  final packages = ValueNotifier(<Package>[]);
  final client = ValueNotifier(Client(client_user: User(user_role: Role())));
  final GetPackagesByClientIdUseCase getPackagesByClientIdUseCase;
  final GetCurrentClientUseCase getCurrentClientUseCase;

  ClientPackagesPageController({
    required this.getPackagesByClientIdUseCase,
    required this.getCurrentClientUseCase
  });

  Future<void> getPackages() async {
    client.value = await getCurrentClientUseCase.exec();
    packages.value = await getPackagesByClientIdUseCase.exec(client.value.client_id!);
  }
}