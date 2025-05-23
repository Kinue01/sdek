import 'package:clientapp/data/repository/delivery_person_data_repository.dart';
import 'package:clientapp/domain/model/DeliveryPerson.dart';
import 'package:clientapp/domain/repository/delivery_person_repository.dart';

class DeliveryPersonRepositoryImpl implements DeliveryPersonRepository {
  final DeliveryPersonDataRepository repository;

  DeliveryPersonRepositoryImpl({
    required this.repository
  });

  @override
  Future<DeliveryPerson> getPersonById(int id) async {
    return await repository.getPersonById(id);
  }

  @override
  Future<List<DeliveryPerson>> getPersonal() async {
    return repository.getPersonal();
  }

  @override
  Future<void> addDeliveryPerson(DeliveryPerson person) async {
    await repository.addDeliveryPerson(person);
  }

  @override
  Future<void> deleteDeliveryPerson(DeliveryPerson person) async {
    await repository.deleteDeliveryPerson(person);
  }

  @override
  Future<void> updateDeliveryPerson(DeliveryPerson person) async {
    await repository.updateDeliveryPerson(person);
  }
}