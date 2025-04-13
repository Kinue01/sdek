import 'package:clientapp/domain/model/Service.dart';

import '../model/PackageServices.dart';

abstract class ServiceRepository {
  Future<Service> getServiceById(int id);
  Future<List<Service>> getServices();
  Future<List<Service>> getServicesByPackageId(String uuid);
  Future<PackageServices> addPackageServices(PackageServices services);
}