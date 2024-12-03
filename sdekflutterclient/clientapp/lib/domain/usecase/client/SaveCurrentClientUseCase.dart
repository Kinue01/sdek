import 'package:clientapp/domain/model/Client.dart';
import 'package:clientapp/domain/repository/current_client_repository.dart';

class SaveCurrentClientUseCase {
  CurrentClientRepository repository;

  SaveCurrentClientUseCase({
    required this.repository
  });

  Future<bool> exec(Client client) async {
    return await repository.saveCurrClient(client);
  }
}