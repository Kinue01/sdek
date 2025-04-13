import '../../domain/model/DeliveryPerson.dart';

abstract class DeliveryPersonDataRepository {
  Future<List<DeliveryPerson>> getPersonal();
  Future<DeliveryPerson> getPersonById(int id);
}
