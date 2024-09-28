import 'package:clientapp/domain/model/Transport.dart';
import 'package:clientapp/domain/repository/transport_repository.dart';

class GetTransportByDriverIdUseCase {
  TransportRepository repository;

  GetTransportByDriverIdUseCase({
    required this.repository
  });

  Future<Transport> exec(String uuid) async {
    return await repository.getTransportByDriverId(uuid);
  }
}