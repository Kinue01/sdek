import 'package:clientapp/domain/model/Transport.dart';

abstract class TransportDataRepository {
  Future<List<Transport>> getTransport();
  Future<Transport> getTransportById(int id);
  Future<Transport> getTransportByDriverId(String uuid);
  Future<bool> addTransport(Transport transport);
  Future<bool> updateTransport(Transport transport);
  Future<bool> deleteTransport(Transport transport);
}