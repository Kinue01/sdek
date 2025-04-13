import 'package:clientapp/domain/model/Transport.dart';

abstract class TransportRepository {
  Future<List<Transport>> getTransport();
  Future<Transport> getTransportById(int id);
  Future<Transport> getTransportByDriverId(int driver);
  Future<bool> addTransport(Transport transport);
  Future<bool> updateTransport(Transport transport);
  Future<bool> deleteTransport(Transport transport);
}