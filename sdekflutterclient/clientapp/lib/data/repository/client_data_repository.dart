import 'package:clientapp/domain/model/Client.dart';

abstract class ClientDataRepository {
  Future<List<Client>> getClients();
  Future<Client> getClientById(int id);
  Future<Client> getClientByUserId(String uuid);
  Future<bool> addClient(Client client);
  Future<bool> updateClient(Client client);
  Future<bool> deleteClient(Client client);
}