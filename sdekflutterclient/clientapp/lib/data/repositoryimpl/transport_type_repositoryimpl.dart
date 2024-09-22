import 'package:clientapp/data/repository/transport_type_data_repository.dart';
import 'package:clientapp/domain/model/TransportType.dart';
import 'package:clientapp/domain/repository/transport_type_repository.dart';

class TransportTypeRepositoryImpl implements TransportTypeRepository {
  TransportTypeDataRepository repository;

  TransportTypeRepositoryImpl({
    required this.repository
  });

  @override
  Future<bool> addTransportType(TransportType type) async {
    return await repository.addTransportType(type);
  }

  @override
  Future<bool> deleteTransportType(TransportType type) async {
    return await repository.deleteTransportType(type);
  }

  @override
  Future<TransportType> getTransportTypeById(int id) async {
    return await repository.getTransportTypeById(id);
  }

  @override
  Future<List<TransportType>> getTransportTypes() async {
    return await repository.getTransportTypes();
  }

  @override
  Future<bool> updateTransportType(TransportType type) async {
    return await repository.updateTransportType(type);
  }
}