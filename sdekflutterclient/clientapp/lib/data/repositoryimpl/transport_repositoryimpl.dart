import 'dart:math';

import 'package:clientapp/data/repository/transport_data_repository.dart';
import 'package:clientapp/domain/model/Employee.dart';
import 'package:clientapp/domain/model/Position.dart';
import 'package:clientapp/domain/model/Role.dart';
import 'package:clientapp/domain/model/Transport.dart';
import 'package:clientapp/domain/model/TransportType.dart';
import 'package:clientapp/domain/model/User.dart';
import 'package:clientapp/domain/repository/transport_repository.dart';
import 'package:clientapp/local/local_storage/transport_local_storage.dart';

class TransportRepositoryImpl implements TransportRepository {
  TransportDataRepository repository;
  TransportLocalStorage transportLocalStorage;

  TransportRepositoryImpl({
    required this.repository,
    required this.transportLocalStorage
  });

  @override
  Future<bool> addTransport(Transport transport) async {
    if (await repository.addTransport(transport)) {
      await transportLocalStorage.saveTransport(transport);
      return true;
    }
    else {
      return false;
    }
  }

  @override
  Future<bool> deleteTransport(Transport transport) async {
    if (await repository.deleteTransport(transport)) {
      await transportLocalStorage.saveTransport(Transport(transport_type: TransportType(), transport_driver: Employee(employee_position: Position(), employee_user: User(user_role: Role()))));
      return true;
    }
    else {
      return false;
    }
  }

  @override
  Future<List<Transport>> getTransport() async {
    final trans = await transportLocalStorage.getTransports();
    if (trans != []) {
      return trans;
    }
    else {
      final res = await repository.getTransport();
      if (res != List.empty()) {
        await transportLocalStorage.saveTransports(res);
      }
      return res;
    }
  }

  @override
  Future<Transport> getTransportByDriverId(String uuid) async {
    final trans = await transportLocalStorage.getTransportByDriver(uuid);
    if (trans.transport_id != 0) {
      return trans;
    }
    else {
      final res = await repository.getTransportByDriverId(uuid);
      if (res.transport_id != 0) {
        await transportLocalStorage.saveTransportByDriver(res);
      }
      return res;
    }
  }

  @override
  Future<Transport> getTransportById(int id) async {
    final trans = await transportLocalStorage.getTransport(id);
    if (trans.transport_id != 0) {
      return trans;
    }
    else {
      final res = await repository.getTransportById(id);
      if (res.transport_id != 0) {
        await transportLocalStorage.saveTransport(res);
      }
      return res;
    }
  }

  @override
  Future<bool> updateTransport(Transport transport) async {
    if (await repository.updateTransport(transport)) {
      await transportLocalStorage.saveTransport(transport);
      return true;
    }
    else {
      return false;
    }
  }
}