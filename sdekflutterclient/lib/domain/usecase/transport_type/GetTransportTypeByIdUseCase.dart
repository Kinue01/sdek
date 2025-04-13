import 'package:clientapp/domain/model/TransportType.dart';
import 'package:clientapp/domain/repository/transport_type_repository.dart';

class GetTransportTypeByIdUseCase {
  TransportTypeRepository repository;

  GetTransportTypeByIdUseCase({
    required this.repository
  });

  Future<TransportType> exec(int id) async {
    return await repository.getTransportTypeById(id);
  }
}