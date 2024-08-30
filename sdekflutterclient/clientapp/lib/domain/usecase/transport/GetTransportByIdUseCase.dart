import 'package:clientapp/domain/model/Transport.dart';
import 'package:clientapp/domain/repository/transport_repository.dart';

class GetTransportByIdUseCase {
  TransportRepository repository;

  GetTransportByIdUseCase({
    required this.repository
  });

  Future<Transport> exec(int id) async {
    return await repository.getTransportById(id);
  }
}