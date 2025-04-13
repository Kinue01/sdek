import 'package:dio/dio.dart';

import '../../domain/model/PackageType.dart';

abstract class PackageTypeApi {
  Future<List<PackageType>> getTypes();
  Future<PackageType> getTypeById(int id);
  Future<bool> addType(PackageType type);
  Future<bool> updateType(PackageType type);
  Future<bool> deleteType(PackageType type);
}

class PackageTypeApiImpl implements PackageTypeApi {
  final Dio client;

  PackageTypeApiImpl({
    required this.client
  });

  String get url => "http://localhost/packageservice";
  String get readUrl => "http://localhost/packagereadservice";

  @override
  Future<bool> addType(PackageType type) async {
    Response response = await client.post("$url/api/type", data: type.toRawJson());
    switch (response.statusCode) {
      case 201:
        return true;
      default:
        return false;
    }
  }

  @override
  Future<bool> deleteType(PackageType type) async {
    Response response = await client.delete("$url/api/type", data: type.toRawJson());
    switch (response.statusCode) {
      case 200:
        return true;
      default:
        return false;
    }
  }

  @override
  Future<PackageType> getTypeById(int id) async {
    Response<Map<String, dynamic>> response = await client.get("$readUrl/api/type", options: Options(extra: {'id': id}));
    switch (response.statusCode) {
      case 200:
        return PackageType.fromMap(response.data!);
      default:
        return PackageType();
    }
  }

  @override
  Future<List<PackageType>> getTypes() async {
    Response<List<dynamic>> response = await client.get("$readUrl/api/package_types");
    switch (response.statusCode) {
      case 200:
        return response.data!.map((e) => PackageType.fromMap(e)).toList();
      default:
        return List.empty();
    }
  }

  @override
  Future<bool> updateType(PackageType type) async {
    Response response = await client.patch("$url/api/type", data: type.toRawJson());
    switch (response.statusCode) {
      case 200:
        return true;
      default:
        return false;
    }
  }
}