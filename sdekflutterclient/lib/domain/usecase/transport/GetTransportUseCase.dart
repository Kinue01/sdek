import 'package:clientapp/domain/model/Transport.dart';
import 'package:clientapp/domain/repository/transport_repository.dart';

class GetTransportUseCase {
  TransportRepository repository;

  GetTransportUseCase({
    required this.repository
  });

  Future<List<Transport>> exec() async {
    return await repository.getTransport();
  }
}