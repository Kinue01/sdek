import 'package:clientapp/domain/model/Package.dart';
import 'package:clientapp/domain/repository/package_repository.dart';

class GetPackagesUseCase {
  PackageRepository repository;

  GetPackagesUseCase({
    required this.repository
  });

  Future<List<Package>> exec() async {
    return await repository.getPackages();
  }
}