import 'package:clientapp/domain/model/DeliveryPerson.dart';
import 'package:clientapp/domain/repository/delivery_person_repository.dart';

class AddDeliveryPersonUseCase {
  final DeliveryPersonRepository repository;

  AddDeliveryPersonUseCase({
    required this.repository
  });

  Future<void> exec(DeliveryPerson person) async {
    await repository.addDeliveryPerson(person);
  }
}