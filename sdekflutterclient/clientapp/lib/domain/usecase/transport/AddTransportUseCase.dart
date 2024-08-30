import 'package:clientapp/domain/model/Transport.dart';
import 'package:clientapp/domain/repository/transport_repository.dart';

class AddTransportUseCase {
  TransportRepository repository;

  AddTransportUseCase({
    required this.repository
  });

  Future<bool> exec(Transport transport) async {
    return await repository.addTransport(transport);
  }
}