import '../model/DeliveryPerson.dart';

abstract class DeliveryPersonRepository {
  Future<List<DeliveryPerson>> getPersonal();
  Future<DeliveryPerson> getPersonById(int id);
}
