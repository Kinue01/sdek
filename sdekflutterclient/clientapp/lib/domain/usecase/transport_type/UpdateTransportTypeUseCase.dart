import 'package:clientapp/domain/model/TransportType.dart';
import 'package:clientapp/domain/repository/transport_type_repository.dart';

class UpdateTransportTypeUseCase {
  TransportTypeRepository repository;

  UpdateTransportTypeUseCase({
    required this.repository
  });

  Future<bool> exec(TransportType type) async {
    return await repository.updateTransportType(type);
  }
}