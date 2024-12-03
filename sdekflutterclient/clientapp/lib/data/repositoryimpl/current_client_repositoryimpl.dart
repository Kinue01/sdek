import 'package:clientapp/domain/model/Client.dart';
import 'package:clientapp/domain/repository/current_client_repository.dart';
import 'package:clientapp/local/local_storage/client_local_storage.dart';

class CurrentClientRepositoryimpl implements CurrentClientRepository {
  ClientLocalStorage localStorage;

  CurrentClientRepositoryimpl({
    required this.localStorage
  }); 

  @override
  Future<Client> getCurrClient() async {
    return await localStorage.getCurrClient();
  }

  @override
  Future<bool> saveCurrClient(Client client) async {
    return await localStorage.saveCurrClient(client);
  }
}