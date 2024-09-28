import 'package:clientapp/data/repository/transport_data_repository.dart';
import 'package:clientapp/domain/model/Transport.dart';
import 'package:clientapp/remote/api/transport_api.dart';

class TransportDataRepositoryImpl implements TransportDataRepository {
  TransportApi transportApi;

  TransportDataRepositoryImpl({
    required this.transportApi
  });

  @override
  Future<bool> addTransport(Transport transport) async {
    return await transportApi.addTransport(transport);
  }

  @override
  Future<bool> deleteTransport(Transport transport) async {
    return await transportApi.deleteTransport(transport);
  }

  @override
  Future<List<Transport>> getTransport() async {
    return await transportApi.getTransport();
  }

  @override
  Future<Transport> getTransportByDriverId(String uuid) async {
    return await transportApi.getTransportByDriverId(uuid);
  }

  @override
  Future<Transport> getTransportById(int id) async {
    return await transportApi.getTransportById(id);
  }

  @override
  Future<bool> updateTransport(Transport transport) async {
    return await transportApi.updateTransport(transport);
  }
}