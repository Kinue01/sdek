import 'package:clientapp/domain/model/Client.dart';
import 'package:clientapp/domain/repository/client_repository.dart';

class GetClientsUseCase {
  ClientRepository repository;

  GetClientsUseCase({
    required this.repository
  });

  Future<List<Client>> exec() async {
    return await repository.getClients();
  }
}