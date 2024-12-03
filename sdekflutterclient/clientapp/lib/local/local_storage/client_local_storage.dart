import 'package:clientapp/domain/model/Client.dart';
import 'package:clientapp/domain/model/Role.dart';
import 'package:clientapp/domain/model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ClientLocalStorage {
  Future<bool> saveClient(Client client);
  Future<bool> saveClients(List<Client> clients);
  Future<List<Client>> getClients();
  Future<Client> getClient(int id);
  Future<bool> saveClientByUser(Client client);
  Future<Client> getClientByUser(String uuid);
  Future<Client> getCurrClient();
  Future<bool> saveCurrClient(Client client);
}

class ClientLocalStorageImpl implements ClientLocalStorage {
  final SharedPreferencesAsync sharedPreferencesAsync;

  ClientLocalStorageImpl({
    required this.sharedPreferencesAsync
  });

  @override
  Future<Client> getClient(int id) async {
    final client = await sharedPreferencesAsync.getString("CLIENT_$id");
    return client != null ? Client.fromRawJsonLocal(client) : Client(client_user: User(user_role: Role()));
  }

  @override
  Future<List<Client>> getClients() async {
    final clients = await sharedPreferencesAsync.getStringList("CLIENTS");
    return clients != null ? clients.map((e) => Client.fromRawJsonLocal(e)).toList() : [];
  }

  @override
  Future<bool> saveClient(Client client) async {
    final key = client.client_id;
    final json = client.toRawJson();
    await sharedPreferencesAsync.setString("CLIENT_$key", json);
    return true;
  }

  @override
  Future<bool> saveClients(List<Client> clients) async {
    await sharedPreferencesAsync.setStringList("CLIENTS", clients.map((e) => e.toRawJson()).toList());
    return true;
  }

  @override
  Future<Client> getClientByUser(String uuid) async {
    final client = await sharedPreferencesAsync.getString("CLIENT_USER_$uuid");
    return client != null ? Client.fromRawJsonLocal(client) : Client(client_user: User(user_role: Role()));
  }

  @override
  Future<bool> saveClientByUser(Client client) async {
    final key = client.client_user.user_id;
    final json = client.toRawJson();
    await sharedPreferencesAsync.setString("CLIENT_USER_$key", json);
    return true;
  }
  
  @override
  Future<Client> getCurrClient() async {
    final client = await sharedPreferencesAsync.getString("CURR_CLIENT");
    return client != null ? Client.fromRawJsonLocal(client) : Client(client_user: User(user_role: Role()));
  }
  
  @override
  Future<bool> saveCurrClient(Client client) async {
    await sharedPreferencesAsync.setString("CURR_CLIENT", client.toRawJson());
    return true;
  }
}