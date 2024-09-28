import 'package:clientapp/domain/model/Package.dart';
import 'package:clientapp/domain/repository/package_repository.dart';

class GetPackageByIdUseCase {
  PackageRepository repository;

  GetPackageByIdUseCase({
    required this.repository
  });

  Future<Package> exec(String uuid) async {
    return await repository.getPackageById(uuid);
  }
}