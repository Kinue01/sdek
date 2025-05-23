import 'package:clientapp/domain/model/DeliveryPerson.dart';
import 'package:clientapp/domain/repository/delivery_person_repository.dart';

class UpdateDeliveryPersonUseCase {
  final DeliveryPersonRepository repository;

  UpdateDeliveryPersonUseCase({
    required this.repository
  });

  Future<void> exec(DeliveryPerson person) async {
    await repository.updateDeliveryPerson(person);
  }
}