import 'package:clientapp/domain/model/Package.dart';
import 'package:dio/dio.dart';

abstract class PackageApi {
  Future<List<Package>> getPackages();
  Future<Package> getPackageById(String uuid);
  Future<List<Package>> getPackagesByClientId(int id);
  Future<bool> addPackage(Package package);
  Future<bool> updatePackage(Package package);
  Future<bool> deletePackage(Package package);
}

class PackageApiImpl implements PackageApi {
  final Dio client;

  PackageApiImpl({
    required this.client
  });

  String get url => "http://localhost/packageservice";
  String get readUrl => "http://localhost/packagereadservice";

  @override
  Future<bool> addPackage(Package package) async {
    Response response = await client.post("$url/api/package", data: package.toRawJson());
    switch (response.statusCode) {
      case 201:
        return true;
      default:
        return false;
    }
  }

  @override
  Future<bool> deletePackage(Package package) async {
    Response response = await client.delete("$url/api/package", data: package.toRawJson());
    switch (response.statusCode) {
      case 200:
        return true;
      default:
        return false;
    }
  }

  @override
  Future<Package> getPackageById(String uuid) async {
    Response<Map<String, dynamic>> response = await client.get("$readUrl/api/package", options: Options(extra: {'uuid': uuid}));
    switch (response.statusCode) {
      case 200:
        return Package.fromMap(response.data!);
      default:
        return Package();
    }
  }

  @override
  Future<List<Package>> getPackages() async {
    Response<List<Map<String, dynamic>>> response = await client.get("$readUrl/api/packages");
    switch (response.statusCode) {
      case 200:
        return response.data!.map((e) => Package.fromMap(e)).toList();
      default:
        return List.empty();
    }
  }

  @override
  Future<List<Package>> getPackagesByClientId(int id) async {
    Response<List<Map<String, dynamic>>> response = await client.get("$readUrl/api/client_packages", options: Options(extra: {'id': id}));
    switch (response.statusCode) {
      case 200:
        return response.data!.map((e) => Package.fromMap(e)).toList();
      default:
        return List.empty();
    }
  }

  @override
  Future<bool> updatePackage(Package package) async {
    Response response = await client.patch("$url/api/package", data: package.toRawJson());
    switch (response.statusCode) {
      case 200:
        return true;
      default:
        return false;
    }
  }
}