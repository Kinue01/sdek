import 'package:clientapp/domain/model/Transport.dart';
import 'package:uuid/uuid.dart';

abstract class TransportRepository {
  Future<List<Transport>> getTransport();
  Future<Transport> getTransportById(int id);
  Future<Transport> getTransportByDriverId(Uuid uuid);
  Future<bool> addTransport(Transport transport);
  Future<bool> updateTransport(Transport transport);
  Future<bool> deleteTransport(Transport transport);
}