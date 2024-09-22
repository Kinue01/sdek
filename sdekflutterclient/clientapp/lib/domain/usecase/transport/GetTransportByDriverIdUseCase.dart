import 'package:clientapp/domain/model/Transport.dart';
import 'package:clientapp/domain/repository/transport_repository.dart';
import 'package:uuid/uuid.dart';

class GetTransportByDriverIdUseCase {
  TransportRepository repository;

  GetTransportByDriverIdUseCase({
    required this.repository
  });

  Future<Transport> exec(Uuid uuid) async {
    return await repository.getTransportByDriverId(uuid);
  }
}