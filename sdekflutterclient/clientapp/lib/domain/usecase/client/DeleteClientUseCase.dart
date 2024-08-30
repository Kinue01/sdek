import 'package:clientapp/domain/model/Client.dart';
import 'package:clientapp/domain/repository/client_repository.dart';

class DeleteClientUseCase {
  ClientRepository repository;

  DeleteClientUseCase({
    required this.repository
  });

  Future<bool> exec(Client client) async {
    return await repository.deleteClient(client);
  }
}