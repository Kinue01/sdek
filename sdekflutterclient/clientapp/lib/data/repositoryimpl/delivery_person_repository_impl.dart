import 'package:clientapp/data/repository/delivery_person_data_repository.dart';
import 'package:clientapp/domain/model/DeliveryPerson.dart';
import 'package:clientapp/domain/repository/delivery_person_repository.dart';

class DeliveryPersonRepositoryImpl implements DeliveryPersonRepository {
  final DeliveryPersonDataRepository repository;

  DeliveryPersonRepositoryImpl({
    required this.repository
  });

  @override
  Future<DeliveryPerson> getPersonById(int id) {
    // TODO: implement getPersonById
    throw UnimplementedError();
  }

  @override
  Future<List<DeliveryPerson>> getPersonal() async {
    return repository.getPersonal();
  }
}