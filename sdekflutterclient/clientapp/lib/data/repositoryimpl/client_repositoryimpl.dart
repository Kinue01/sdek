import 'package:clientapp/data/repository/client_data_repository.dart';
import 'package:clientapp/domain/model/Client.dart';
import 'package:clientapp/domain/repository/client_repository.dart';

class ClientRepositoryImpl implements ClientRepository {
  ClientDataRepository repository;

  ClientRepositoryImpl({
    required this.repository
  });

  @override
  Future<bool> addClient(Client client) async {
    return await repository.addClient(client);
  }

  @override
  Future<bool> deleteClient(Client client) async {
    return await repository.deleteClient(client);
  }

  @override
  Future<Client> getClientById(int id) async {
    return await repository.getClientById(id);
  }

  @override
  Future<Client> getClientByUserId(String uuid) async {
    return await repository.getClientByUserId(uuid);
  }

  @override
  Future<List<Client>> getClients() async {
    return await repository.getClients();
  }

  @override
  Future<bool> updateClient(Client client) async {
    return await repository.updateClient(client);
  }
}