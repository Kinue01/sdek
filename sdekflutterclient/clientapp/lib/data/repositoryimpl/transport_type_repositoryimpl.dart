import 'dart:math';

import 'package:clientapp/data/repository/transport_type_data_repository.dart';
import 'package:clientapp/domain/model/TransportType.dart';
import 'package:clientapp/domain/repository/transport_type_repository.dart';
import 'package:clientapp/local/local_storage/transport_type_local_storage.dart';

class TransportTypeRepositoryImpl implements TransportTypeRepository {
  TransportTypeDataRepository repository;
  TransportTypeLocalStorage transportTypeLocalStorage;

  TransportTypeRepositoryImpl({
    required this.repository,
    required this.transportTypeLocalStorage
  });

  @override
  Future<bool> addTransportType(TransportType type) async {
    if (await repository.addTransportType(type)) {
      await transportTypeLocalStorage.saveTransportType(type);
      return true;
    }
    else {
      return false;
    }
  }

  @override
  Future<bool> deleteTransportType(TransportType type) async {
    if (await repository.deleteTransportType(type)) {
      await transportTypeLocalStorage.saveTransportType(TransportType());
      return true;
    }
    else {
      return false;
    }
  }

  @override
  Future<TransportType> getTransportTypeById(int id) async {
    final type = await transportTypeLocalStorage.getTransportType(id);
    if (type.type_id != 0) {
      return type;
    }
    else {
      final res = await repository.getTransportTypeById(id);
      if (res.type_id != 0) {
        await transportTypeLocalStorage.saveTransportType(res);
      }
      return res;
    }
  }

  @override
  Future<List<TransportType>> getTransportTypes() async {
    final types = await transportTypeLocalStorage.getTransportTypes();
    if (types != []) {
      return types;
    }
    else {
      final res = await repository.getTransportTypes();
      if (res != List.empty()) {
        await transportTypeLocalStorage.saveTransportTypes(res);
      }
      return res;
    }
  }

  @override
  Future<bool> updateTransportType(TransportType type) async {
    if (await repository.updateTransportType(type)) {
      await transportTypeLocalStorage.saveTransportType(type);
      return true;
    }
    else {
      return false;
    }
  }
}