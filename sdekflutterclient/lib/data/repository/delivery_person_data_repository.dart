import '../../domain/model/DeliveryPerson.dart';

abstract class DeliveryPersonDataRepository {
  Future<List<DeliveryPerson>> getPersonal();
  Future<DeliveryPerson> getPersonById(int id);
  Future<void> addDeliveryPerson(DeliveryPerson person);
  Future<void> updateDeliveryPerson(DeliveryPerson person);
  Future<void> deleteDeliveryPerson(DeliveryPerson person);
}
