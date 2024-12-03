import 'package:clientapp/domain/model/Service.dart';

import '../../domain/model/PackageServices.dart';

abstract class ServiceDataRepository {
  Future<Service> getServiceById(int id);
  Future<List<Service>> getServices();
  Future<List<Service>> getServicesByPackageId(String uuid);
  Future<PackageServices> addPackageServices(PackageServices services);
}