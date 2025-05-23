import 'package:clientapp/domain/model/DeliveryPerson.dart';
import 'package:clientapp/domain/repository/delivery_person_repository.dart';

class DeleteDeliveryPersonUseCase {
  final DeliveryPersonRepository repository;

  DeleteDeliveryPersonUseCase({
    required this.repository
  });

  Future<void> exec(DeliveryPerson person) async {
    await repository.deleteDeliveryPerson(person);
  }
}