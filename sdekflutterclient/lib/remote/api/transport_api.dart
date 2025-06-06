import 'package:clientapp/domain/model/TransportType.dart';
import 'package:dio/dio.dart';

import '../../Env.dart';
import '../../domain/model/Transport.dart';

abstract class TransportApi {
  Future<List<Transport>> getTransport();
  Future<Transport> getTransportById(int id);
  Future<Transport> getTransportByDriverId(int driver);
  Future<bool> addTransport(Transport transport);
  Future<bool> updateTransport(Transport transport);
  Future<bool> deleteTransport(Transport transport);
}

class TransportApiImpl implements TransportApi {
  final Dio client;
  
  TransportApiImpl({
    required this.client
  });

  String get url => "${Env.prod_api_url}/transportservice";
  String get readUrl => "${Env.prod_api_url}/transportreadservice";
  
  @override
  Future<bool> addTransport(Transport transport) async {
    Response response = await client.post("$url/api/transport", data: transport.toRawJson());
    switch (response.statusCode) {
      case 201:
        return true;
      default:
        return false;
    }
  }

  @override
  Future<bool> deleteTransport(Transport transport) async {
    Response response = await client.delete("$url/api/transport", data: transport.toRawJson());
    switch (response.statusCode) {
      case 200:
        return true;
      default:
        return false;
    }
  }

  @override
  Future<List<Transport>> getTransport() async {
    Response<List<Map<String, dynamic>>> response = await client.get("$readUrl/api/transports");
    switch (response.statusCode) {
      case 200:
        return response.data!.map((e) => Transport.fromMap(e)).toList();
      default:
        return List.empty();
    }
  }

  @override
  Future<Transport> getTransportByDriverId(int driver) async {
    Response<Map<String, dynamic>> response = await client.get("$readUrl/api/transport_driver", options: Options(extra: {'id': driver}));
    switch (response.statusCode) {
      case 200:
        return Transport.fromMap(response.data!);
      default:
        return Transport(transport_type: TransportType());
    }
  }

  @override
  Future<Transport> getTransportById(int id) async {
    Response<Map<String, dynamic>> response = await client.get("$readUrl/api/transport", options: Options(extra: {'id': id}));
    switch (response.statusCode) {
      case 200:
        return Transport.fromMap(response.data!);
      default:
        return Transport(transport_type: TransportType());
    }
  }

  @override
  Future<bool> updateTransport(Transport transport) async {
    Response response = await client.patch("$url/api/transport", data: transport.toRawJson());
    switch (response.statusCode) {
      case 200:
        return true;
      default:
        return false;
    }
  }
}