import 'package:clientapp/domain/model/Service.dart';
import 'package:clientapp/domain/repository/service_repository.dart';

class GetAllServicesUseCase {
  final ServiceRepository repository;

  GetAllServicesUseCase({
    required this.repository
  });

  Future<List<Service>> exec() async {
    return await repository.getServices();
  }
}