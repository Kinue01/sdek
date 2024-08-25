import 'package:clientapp/domain/model/TransportType.dart';

abstract class TransportTypeRepository {
  Future<List<TransportType>> getTransportTypes();
  Future<TransportType> getTransportTypeById();
  Future<bool> addTransportType(TransportType type);
  Future<bool> updateTransportType(TransportType type);
  Future<bool> deleteTransportType(TransportType type);
}