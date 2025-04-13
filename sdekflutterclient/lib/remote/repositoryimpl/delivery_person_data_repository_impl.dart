import 'package:clientapp/domain/model/DeliveryPerson.dart';
import 'package:clientapp/remote/api/delivery_person_api.dart';

import '../../data/repository/delivery_person_data_repository.dart';

class DeliveryPersonDataRepositoryImpl implements DeliveryPersonDataRepository {
  final DeliveryPersonApi api;

  DeliveryPersonDataRepositoryImpl({
    required this.api
  });

  @override
  Future<DeliveryPerson> getPersonById(int id) {
    // TODO: implement getPersonById
    throw UnimplementedError();
  }

  @override
  Future<List<DeliveryPerson>> getPersonal() async {
    return api.getPersonal();
  }
}