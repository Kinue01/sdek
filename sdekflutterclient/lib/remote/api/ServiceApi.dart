import 'package:clientapp/domain/model/PackageServices.dart';
import 'package:clientapp/domain/model/Service.dart';
import 'package:dio/dio.dart';

abstract class ServiceApi {
  Future<Service> getServiceById(int id);
  Future<List<Service>> getServices();
  Future<List<Service>> getServicesByPackageId(String uuid);
  Future<PackageServices> addPackageServices(PackageServices services);
}

class ServiceApiImpl implements ServiceApi {
  final Dio client;

  ServiceApiImpl({
    required this.client
  });

  String get url => "http://localhost/servicesservice";
  String get readUrl => "http://localhost/servicesreadservice";
  
  @override
  Future<Service> getServiceById(int id) async {
    Response<Map<String, dynamic>> response = await client.get("$readUrl/api/service", options: Options(extra: {'id': id}));
    if (response.statusCode != 200) return Service();
    return Service.fromMap(response.data!);
  }

  @override
  Future<List<Service>> getServices() async {
    Response<List<dynamic>> response = await client.get("$readUrl/api/services");
    if (response.statusCode != 200) return List.empty();
    return response.data!.map((s) => Service.fromMap(s)).toList();
  }

  @override
  Future<List<Service>> getServicesByPackageId(String uuid) async {
    Response<List<dynamic>> response = await client.get("$readUrl/api/package_services", options: Options(extra: {'packageId': uuid}));
    if (response.statusCode != 200) return List.empty();
    return response.data!.map((s) => Service.fromMap(s)).toList();
  }

  @override
  Future<PackageServices> addPackageServices(PackageServices services) async {
    var map = services.toMap();
    var json = services.toRawJson();
    Response response = await client.post("$url/api/services", data: services.toRawJson());
    if (response.statusCode != 200) return PackageServices();
    return PackageServices.fromMap(response.data);
  }
}