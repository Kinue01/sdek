import 'package:clientapp/domain/model/TransportType.dart';
import 'package:clientapp/domain/repository/transport_type_repository.dart';

class GetTransportTypesUseCase {
  TransportTypeRepository repository;

  GetTransportTypesUseCase({
    required this.repository
  });

  Future<List<TransportType>> exec() async {
    return await repository.getTransportTypes();
  }
}