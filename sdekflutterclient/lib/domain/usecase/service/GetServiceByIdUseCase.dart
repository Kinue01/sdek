import 'package:clientapp/domain/model/Service.dart';

import '../../repository/service_repository.dart';

class GetServiceByIdUseCase {
  final ServiceRepository repository;

  GetServiceByIdUseCase({
    required this.repository
  });

  Future<Service> exec(int id) async {
    return await repository.getServiceById(id);
  }
}