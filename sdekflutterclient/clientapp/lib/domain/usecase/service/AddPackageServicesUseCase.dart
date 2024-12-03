import 'package:clientapp/domain/model/PackageServices.dart';
import 'package:clientapp/domain/repository/service_repository.dart';

class AddPackageServicesUseCase {
  final ServiceRepository repository;

  AddPackageServicesUseCase({
    required this.repository
  });

  Future<PackageServices> exec(PackageServices services) async {
    return await repository.addPackageServices(services);
  }
}