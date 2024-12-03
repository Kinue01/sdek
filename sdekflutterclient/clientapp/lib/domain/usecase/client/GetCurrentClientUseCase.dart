import 'package:clientapp/domain/model/Client.dart';
import 'package:clientapp/domain/repository/current_client_repository.dart';

class GetCurrentClientUseCase {
  CurrentClientRepository repository;

  GetCurrentClientUseCase({
    required this.repository
  });

  Future<Client> exec() async {
    return await repository.getCurrClient();
  }
}