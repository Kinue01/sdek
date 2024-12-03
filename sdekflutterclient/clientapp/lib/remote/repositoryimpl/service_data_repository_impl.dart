import 'package:clientapp/data/repository/service_data_repository.dart';
import 'package:clientapp/domain/model/PackageServices.dart';
import 'package:clientapp/domain/model/Service.dart';
import 'package:clientapp/remote/api/ServiceApi.dart';

class ServiceDataRepositoryImpl implements ServiceDataRepository {
  final ServiceApi api;

  ServiceDataRepositoryImpl({
    required this.api
  });

  @override
  Future<Service> getServiceById(int id) async {
    return await api.getServiceById(id);
  }

  @override
  Future<List<Service>> getServices() async {
    return await api.getServices();
  }

  @override
  Future<List<Service>> getServicesByPackageId(String uuid) async {
    return await api.getServicesByPackageId(uuid);
  }

  @override
  Future<PackageServices> addPackageServices(PackageServices services) async {
    return await api.addPackageServices(services);
  }
}