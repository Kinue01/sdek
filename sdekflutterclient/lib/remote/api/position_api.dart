import 'package:dio/dio.dart';

import '../../Env.dart';
import '../../domain/model/Position.dart';

abstract class PositionApi {
  Future<List<Position>> getPositions();
  Future<Position> getPositionById(int id);
  Future<bool> addPosition(Position pos);
  Future<bool> updatePosition(Position pos);
  Future<bool> deletePosition(Position pos);
}

class PositionApiImpl implements PositionApi {
  final Dio client;

  PositionApiImpl({
    required this.client
  });

  String get url => "${Env.prod_api_url}/employeeservice";
  String get readUrl => "${Env.prod_api_url}/employeereadservice";

  @override
  Future<bool> addPosition(Position pos) async {
    Response resp = await client.post("$url/api/position", data: pos.toRawJson());
    switch (resp.statusCode) {
      case 201:
        return true;
      default:
        return false;
    }
  }

  @override
  Future<bool> deletePosition(Position pos) async {
    Response resp = await client.delete("$url/api/position", data: pos.toRawJson());
    switch (resp.statusCode) {
      case 200:
        return true;
      default:
        return false;
    }
  }

  @override
  Future<Position> getPositionById(int id) async {
    Response<Map<String, dynamic>> response = await client.get("$readUrl/api/position", options: Options(extra: {'id': id}));
    switch (response.statusCode) {
      case 200:
        return Position.fromMap(response.data!);
      default:
        return Position();
    }
  }

  @override
  Future<List<Position>> getPositions() async {
    Response<List<dynamic>> response = await client.get("$readUrl/api/positions");
    switch (response.statusCode) {
      case 200:
        return response.data!.map((e) => Position.fromMap(e)).toList();
      default:
        return List.empty();
    }
  }

  @override
  Future<bool> updatePosition(Position pos) async {
    Response response = await client.patch("$url/api/position", data: pos.toRawJson());
    switch (response.statusCode) {
      case 200:
        return true;
      default:
        return false;
    }
  }
}