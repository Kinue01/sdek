import 'package:clientapp/domain/model/PackagePaytype.dart';
import 'package:dio/dio.dart';

abstract class PackagePaytypeApi {
  Future<List<PackagePaytype>> getAllPaytypes();
  Future<PackagePaytype> getPaytypeById(int id);
}

class PackagePaytypeApiImpl implements PackagePaytypeApi {
  final Dio client;

  PackagePaytypeApiImpl({
    required this.client
  });

  String get readUrl => "http://localhost:8080/packagereadservice";

  @override
  Future<List<PackagePaytype>> getAllPaytypes() async {
    Response<List<dynamic>> response = await client.get("$readUrl/api/package_paytypes");
    if (response.statusCode != 200) return List.empty();
    return response.data!.map((e) => PackagePaytype.fromMap(e)).toList();
  }

  @override
  Future<PackagePaytype> getPaytypeById(int id) async {
    // TODO: implement getPaytypeById
    throw UnimplementedError();
  }
}