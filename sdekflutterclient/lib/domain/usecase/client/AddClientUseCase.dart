import 'package:clientapp/domain/model/Client.dart';
import 'package:clientapp/domain/repository/client_repository.dart';

class AddClientUseCase {
  ClientRepository repository;

  AddClientUseCase({
    required this.repository
  });

  Future<bool> exec(Client client) async {
    return await repository.addClient(client);
  }
}