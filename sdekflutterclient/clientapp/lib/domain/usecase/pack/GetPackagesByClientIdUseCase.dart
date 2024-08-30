import 'package:clientapp/domain/model/Package.dart';
import 'package:clientapp/domain/repository/package_repository.dart';

class GetPackagesByClientIdUseCase {
  PackageRepository repository;

  GetPackagesByClientIdUseCase({
    required this.repository
  });

  Future<List<Package>> exec(int id) async {
    return await repository.getPackagesByClientId(id);
  }
}