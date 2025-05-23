import 'package:clientapp/domain/model/DeliveryPerson.dart';
import 'package:clientapp/remote/api/delivery_person_api.dart';

import '../../data/repository/delivery_person_data_repository.dart';

class DeliveryPersonDataRepositoryImpl implements DeliveryPersonDataRepository {
  final DeliveryPersonApi api;

  DeliveryPersonDataRepositoryImpl({
    required this.api
  });

  @override
  Future<DeliveryPerson> getPersonById(int id) async {
    return await api.getPersonById(id);
  }

  @override
  Future<List<DeliveryPerson>> getPersonal() async {
    return api.getPersonal();
  }

  @override
  Future<void> addDeliveryPerson(DeliveryPerson person) async {
    await api.addDeliveryPerson(person);
  }

  @override
  Future<void> deleteDeliveryPerson(DeliveryPerson person) async {
    await api.deleteDeliveryPerson(person);
  }

  @override
  Future<void> updateDeliveryPerson(DeliveryPerson person) async {
    await api.updateDeliveryPerson(person);
  }
}