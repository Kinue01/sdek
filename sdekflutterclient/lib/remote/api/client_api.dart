import 'package:clientapp/domain/model/Role.dart';
import 'package:clientapp/domain/model/User.dart';
import 'package:dio/dio.dart';

import '../../Env.dart';
import '../../domain/model/Client.dart';

abstract class ClientApi {
  Future<List<Client>> getClients();
  Future<Client> getClientById(int id);
  Future<Client> getClientByUserId(String uuid);
  Future<bool> addClient(Client client);
  Future<bool> updateClient(Client client);
  Future<bool> deleteClient(Client client);
}

class ClientApiImpl implements ClientApi {
  final Dio dio_client;

  ClientApiImpl({
    required this.dio_client
  });

  String get url => "${Env.prod_api_url}/customerservice";
  String get readUrl => "${Env.prod_api_url}/customerreadservice";

  @override
  Future<bool> addClient(Client client) async {
    Response response = await dio_client.post("$url/api/client", data: client.toRawJson());
    switch (response.statusCode) {
      case 201:
        return true;
      default:
        return false;
    }
  }

  @override
  Future<bool> deleteClient(Client client) async {
    Response response = await dio_client.delete("$url/api/client", data: client.toRawJson());
    switch (response.statusCode) {
      case 200:
        return true;
      default:
        return false;
    }
  }

  @override
  Future<Client> getClientById(int id) async {
    Response<Map<String, dynamic>> response = await dio_client.get("$readUrl/api/client", options: Options(extra: {'id': id}));
    switch (response.statusCode) {
      case 200:
        return Client.fromMap(response.data!);
      default:
        return Client(client_user: User(user_role: Role()));
    }
  }

  @override
  Future<Client> getClientByUserId(String uuid) async {
    Response<Map<String, dynamic>> response = await dio_client.get("$readUrl/api/client_user?uuid=$uuid");
    switch (response.statusCode) {
      case 200:
        return Client.fromMap(response.data!);
      default:
        return Client(client_user: User(user_role: Role()));
    }
  }

  @override
  Future<List<Client>> getClients() async {
    Response<List<dynamic>> response = await dio_client.get("$readUrl/api/clients");
    switch (response.statusCode) {
      case 200:
        return response.data!.map((e) => Client.fromMap(e)).toList();
      default:
        return List.empty();
    }
  }

  @override
  Future<bool> updateClient(Client client) async {
    Response response = await dio_client.patch("$url/api/client", data: client.toRawJson());
    switch (response.statusCode) {
      case 200:
        return true;
      default:
        return false;
    }
  }
}