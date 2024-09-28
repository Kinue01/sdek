import 'package:clientapp/data/repository/transport_type_data_repository.dart';
import 'package:clientapp/domain/model/TransportType.dart';
import 'package:clientapp/remote/api/transport_type_api.dart';

class TransportTypeDataRepositoryImpl implements TransportTypeDataRepository {
  TransportTypeApi transportTypeApi;

  TransportTypeDataRepositoryImpl({
    required this.transportTypeApi
  });

  @override
  Future<bool> addTransportType(TransportType type) async {
    return await transportTypeApi.addTransportType(type);
  }

  @override
  Future<bool> deleteTransportType(TransportType type) async {
    return await transportTypeApi.deleteTransportType(type);
  }

  @override
  Future<TransportType> getTransportTypeById(int id) async {
    return await transportTypeApi.getTransportTypeById(id);
  }

  @override
  Future<List<TransportType>> getTransportTypes() async {
    return await transportTypeApi.getTransportTypes();
  }

  @override
  Future<bool> updateTransportType(TransportType type) async {
    return await transportTypeApi.updateTransportType(type);
  }
}