import 'package:clientapp/domain/model/DeliveryPerson.dart';
import 'package:clientapp/domain/repository/delivery_person_repository.dart';

class GetDeliveryPersonalUseCase {
  final DeliveryPersonRepository repository;

  GetDeliveryPersonalUseCase({
    required this.repository
  });

  Future<List<DeliveryPerson>> exec() async {
    return repository.getPersonal();
  }
}