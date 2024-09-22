import 'package:clientapp/domain/model/Package.dart';
import 'package:clientapp/domain/repository/package_repository.dart';
import 'package:uuid/uuid.dart';

class GetPackageByIdUseCase {
  PackageRepository repository;

  GetPackageByIdUseCase({
    required this.repository
  });

  Future<Package> exec(Uuid uuid) async {
    return await repository.getPackageById(uuid);
  }
}