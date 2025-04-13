import 'package:clientapp/data/repository/client_data_repository.dart';
import 'package:clientapp/domain/model/Client.dart';
import 'package:clientapp/domain/model/Role.dart';
import 'package:clientapp/domain/model/User.dart';
import 'package:clientapp/domain/repository/client_repository.dart';
import 'package:clientapp/local/local_storage/client_local_storage.dart';

class ClientRepositoryImpl implements ClientRepository {
  ClientDataRepository repository;
  ClientLocalStorage clientLocalStorage;

  ClientRepositoryImpl({
    required this.repository,
    required this.clientLocalStorage
  });

  @override
  Future<bool> addClient(Client client) async {
    if (await repository.addClient(client)) {
      //await clientLocalStorage.saveClient(client);
      return true;
    }
    else {
      return false;
    }
  }

  @override
  Future<bool> deleteClient(Client client) async {
    if (await repository.deleteClient(client)) {
      //await clientLocalStorage.saveClient(Client(client_user: User(user_role: Role())));
      return true;
    }
    else {
      return false;
    }
  }

  @override
  Future<Client> getClientById(int id) async {
    // final client = await clientLocalStorage.getClient(id);
    // if (client.client_id != 0) {
    //   return client;
    // }
    // else {
    //   final res = await repository.getClientById(id);
    //   if (res.client_id != 0) {
    //     await clientLocalStorage.saveClient(res);
    //   }
    //   return res;
    // }
   return await repository.getClientById(id);
  }

  @override
  Future<Client> getClientByUserId(String uuid) async {
    // final client = await clientLocalStorage.getClientByUser(uuid);
    // if (client.client_id != null) {
    //   return client;
    // }
    // else {
    //   final res = await repository.getClientByUserId(uuid);
    //   if (res.client_id != 0) {
    //     await clientLocalStorage.saveClientByUser(res);
    //   }
    //   return res;
    // }
    return await repository.getClientByUserId(uuid);
  }

  @override
  Future<List<Client>> getClients() async {
    // final clients = await clientLocalStorage.getClients();
    // if (clients != []) {
    //   return clients;
    // }
    // else {
    //   final res = await repository.getClients();
    //   if (res != List.empty()) {
    //     await clientLocalStorage.saveClients(res);
    //   }
    //   return res;
    // }
    return await repository.getClients();
  }

  @override
  Future<bool> updateClient(Client client) async {
    if (await repository.updateClient(client)) {
      //await clientLocalStorage.saveClient(client);
      return true;
    }
    else {
      return false;
    }
  }
}