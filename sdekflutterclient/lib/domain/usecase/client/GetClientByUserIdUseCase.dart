import 'package:clientapp/domain/model/Client.dart';
import 'package:clientapp/domain/repository/client_repository.dart';

class GetClientByUserIdUseCase {
  ClientRepository repository;

  GetClientByUserIdUseCase({
    required this.repository
  });

  Future<Client> exec(String uuid) async {
    return await repository.getClientByUserId(uuid);
  }
}