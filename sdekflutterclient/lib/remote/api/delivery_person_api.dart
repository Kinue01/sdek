import 'package:clientapp/domain/model/DeliveryPerson.dart';
import 'package:dio/dio.dart';

import '../../Env.dart';

abstract class DeliveryPersonApi {
  Future<List<DeliveryPerson>> getPersonal();
  Future<DeliveryPerson> getPersonById(int id);
  Future<void> addDeliveryPerson(DeliveryPerson person);
  Future<void> updateDeliveryPerson(DeliveryPerson person);
  Future<void> deleteDeliveryPerson(DeliveryPerson person);
}

class DeliveryPersonApiImpl implements DeliveryPersonApi {
  final Dio client;

  DeliveryPersonApiImpl({
    required this.client
  });

  String get readUrl => "${Env.prod_api_url}/deliverypersonellreadservice";
  String get url => "${Env.prod_api_url}/deliverypersonellservice";

  @override
  Future<DeliveryPerson> getPersonById(int id) async {
    Response<Map<String, dynamic>> response = await client.get("$readUrl/delivery_person/$id");
    if (response.statusCode != 200) return DeliveryPerson();
    return DeliveryPerson.fromMap(response.data!);
  }

  @override
  Future<List<DeliveryPerson>> getPersonal() async {
    Response<List<dynamic>> response = await client.get("$readUrl/api/delivery_personell");
    if (response.statusCode != 200) return List.empty();
    return response.data!.map((e) => DeliveryPerson.fromMap(e)).toList();
  }

  @override
  Future<void> addDeliveryPerson(DeliveryPerson person) async {
    await client.post("$url/api/delivery_person", data: person.toRawJson());
  }

  @override
  Future<void> deleteDeliveryPerson(DeliveryPerson person) async {
    await client.delete("$url/api/delivery_person", data: person.toRawJson());
  }

  @override
  Future<void> updateDeliveryPerson(DeliveryPerson person) async {
    await client.patch("$url/api/delivery_person", data: person.toRawJson());
  }
}