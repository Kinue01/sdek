import 'package:clientapp/domain/model/TransportType.dart';
import 'package:dio/dio.dart';

abstract class TransportTypeApi {
  Future<List<TransportType>> getTransportTypes();
  Future<TransportType> getTransportTypeById(int id);
  Future<bool> addTransportType(TransportType type);
  Future<bool> updateTransportType(TransportType type);
  Future<bool> deleteTransportType(TransportType type);
}

class TransportTypeApiImpl implements TransportTypeApi {
  final Dio client;

  TransportTypeApiImpl({
    required this.client
  });

  String get url => "http://localhost:8080/transportservice";
  String get readUrl => "http://localhost:8080/transportreadservice";

  @override
  Future<bool> addTransportType(TransportType type) async {
    Response resp = await client.post("$url/api/type", data: type.toRawJson());
    if (resp.statusCode == 201) {
      return true;
    }
    else {
      return false;
    }
  }

  @override
  Future<bool> deleteTransportType(TransportType type) async {
    Response resp = await client.delete("$url/api/type", data: type.toRawJson());
    switch (resp.statusCode) {
      case 200:
        return true;
      default:
        return false;
    }
  }

  @override
  Future<TransportType> getTransportTypeById(int id) async {
    Response<Map<String, dynamic>> resp = await client.get("$readUrl/api/type", options: Options(extra: {'id': id}));
    switch (resp.statusCode) {
      case 200:
        return TransportType.fromMap(resp.data!);
      default:
        return TransportType();
    }
  }

  @override
  Future<List<TransportType>> getTransportTypes() async {
    Response<List<Map<String, dynamic>>> resp = await client.get("$readUrl/api/types");
    switch (resp.statusCode) {
      case 200:
        return resp.data!.map((e) => TransportType.fromMap(e)).toList();
      default:
        return List.empty();
    }
  }

  @override
  Future<bool> updateTransportType(TransportType type) async {
    Response resp = await client.patch("$url/api/type", data: type.toRawJson());
    switch (resp.statusCode) {
      case 200:
        return true;
      default:
        return false;
    }
  }
}