import 'package:clientapp/domain/model/Client.dart';
import '../../repository/client_repository.dart';

class GetClientByIdUseCase {
  ClientRepository repository;

  GetClientByIdUseCase({
    required this.repository
  });

  Future<Client> exec(int id) async {
    return await repository.getClientById(id);
  }
}