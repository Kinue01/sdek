import 'package:clientapp/data/repository/service_data_repository.dart';
import 'package:clientapp/domain/model/PackageServices.dart';
import 'package:clientapp/domain/model/Service.dart';

import '../../domain/repository/service_repository.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceDataRepository repository;

  ServiceRepositoryImpl({
    required this.repository
  });

  @override
  Future<Service> getServiceById(int id) async {
    return await repository.getServiceById(id);
  }

  @override
  Future<List<Service>> getServices() async {
    return await repository.getServices();
  }

  @override
  Future<List<Service>> getServicesByPackageId(String uuid) async {
    return await repository.getServicesByPackageId(uuid);
  }

  @override
  Future<PackageServices> addPackageServices(PackageServices services) async {
    return await repository.addPackageServices(services);
  }
}