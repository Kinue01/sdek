import 'package:clientapp/data/repository/transport_data_repository.dart';
import 'package:clientapp/domain/model/Transport.dart';
import 'package:clientapp/domain/repository/transport_repository.dart';
import 'package:uuid/uuid.dart';

class TransportRepositoryImpl implements TransportRepository {
  TransportDataRepository repository;

  TransportRepositoryImpl({
    required this.repository
  });

  @override
  Future<bool> addTransport(Transport transport) async {
    return await repository.addTransport(transport);
  }

  @override
  Future<bool> deleteTransport(Transport transport) async {
    return await repository.deleteTransport(transport);
  }

  @override
  Future<List<Transport>> getTransport() async {
    return await repository.getTransport();
  }

  @override
  Future<Transport> getTransportByDriverId(Uuid uuid) async {
    return await repository.getTransportByDriverId(uuid);
  }

  @override
  Future<Transport> getTransportById(int id) async {
    return await repository.getTransportById(id);
  }

  @override
  Future<bool> updateTransport(Transport transport) async {
    return await repository.updateTransport(transport);
  }
}