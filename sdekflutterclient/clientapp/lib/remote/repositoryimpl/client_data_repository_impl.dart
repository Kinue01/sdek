import 'package:clientapp/data/repository/client_data_repository.dart';
import 'package:clientapp/domain/model/Client.dart';
import 'package:clientapp/remote/api/client_api.dart';

class ClientDataRepositoryImpl implements ClientDataRepository {
  ClientApi clientApi;

  ClientDataRepositoryImpl({
    required this.clientApi
  });

  @override
  Future<bool> addClient(Client client) async {
    return await clientApi.addClient(client);
  }

  @override
  Future<bool> deleteClient(Client client) async {
    return await clientApi.deleteClient(client);
  }

  @override
  Future<Client> getClientById(int id) async {
    return await clientApi.getClientById(id);
  }

  @override
  Future<Client> getClientByUserId(String uuid) async {
    return await clientApi.getClientByUserId(uuid);
  }

  @override
  Future<List<Client>> getClients() async {
    return await clientApi.getClients();
  }

  @override
  Future<bool> updateClient(Client client) async {
    return await clientApi.updateClient(client);
  }
}