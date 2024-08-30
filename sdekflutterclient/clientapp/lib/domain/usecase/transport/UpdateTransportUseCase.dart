import 'package:clientapp/domain/model/Transport.dart';
import 'package:clientapp/domain/repository/transport_repository.dart';

class UpdateTransportUseCase {
  TransportRepository repository;

  UpdateTransportUseCase({
    required this.repository
  });

  Future<bool> exec(Transport transport) async {
    return await repository.updateTransport(transport);
  }
}