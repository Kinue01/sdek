import 'package:clientapp/domain/model/Service.dart';

import '../../repository/service_repository.dart';

class GetServicesByPackageIdUseCase {
  final ServiceRepository repository;

  GetServicesByPackageIdUseCase({
    required this.repository
  });

  Future<List<Service>> exec(String uuid) async {
    return await repository.getServicesByPackageId(uuid);
  }
}