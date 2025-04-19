import 'package:dio/dio.dart';

import '../../domain/model/PackageStatus.dart';

abstract class PackageStatusApi {
  Future<List<PackageStatus>> getStatuses();
  Future<PackageStatus> getPackageStatusById(int id);
  Future<bool> addStatus(PackageStatus status);
  Future<bool> updateStatus(PackageStatus status);
  Future<bool> deleteStatus(PackageStatus status);
}

class PackageStatusApiImpl implements PackageStatusApi {
  final Dio client;

  PackageStatusApiImpl({
    required this.client
  });

  String get url => "http://localhost:8080/packageservice";
  String get readUrl => "http://localhost:8080/packagereadservice";

  @override
  Future<bool> addStatus(PackageStatus status) async {
    Response response = await client.post("$url/api/status", data: status.toRawJson());
    switch (response.statusCode) {
      case 201:
        return true;
      default:
        return false;
    }
  }

  @override
  Future<bool> deleteStatus(PackageStatus status) async {
    Response response = await client.delete("$url/api/status", data: status.toRawJson());
    switch (response.statusCode) {
      case 200:
        return true;
      default:
        return false;
    }
  }

  @override
  Future<PackageStatus> getPackageStatusById(int id) async {
    Response<Map<String, dynamic>> response = await client.get("$readUrl/api/status", options: Options(extra: {'id': id}));
    switch (response.statusCode) {
      case 200:
        return PackageStatus.fromMap(response.data!);
      default:
        return PackageStatus();
    }
  }

  @override
  Future<List<PackageStatus>> getStatuses() async {
    Response<List<Map<String, dynamic>>> response = await client.get("$readUrl/api/statuses");
    switch (response.statusCode) {
      case 200:
        return response.data!.map((e) => PackageStatus.fromMap(e)).toList();
      default:
        return List.empty();
    }
  }

  @override
  Future<bool> updateStatus(PackageStatus status) async {
    Response response = await client.patch("$url/api/status", data: status.toRawJson());
    switch (response.statusCode) {
      case 200:
        return true;
      default:
        return false;
    }
  }
}