import 'package:clientapp/domain/model/DeliveryPerson.dart';
import 'package:dio/dio.dart';

import '../../Env.dart';

abstract class DeliveryPersonApi {
  Future<List<DeliveryPerson>> getPersonal();
  Future<DeliveryPerson> getPersonById(int id);
}

class DeliveryPersonApiImpl implements DeliveryPersonApi {
  final Dio client;

  DeliveryPersonApiImpl({
    required this.client
  });

  String get readUrl => "${Env.prod_api_url}/deliverypersonellreadservice";

  @override
  Future<DeliveryPerson> getPersonById(int id) {
    // TODO: implement getPersonById
    throw UnimplementedError();
  }

  @override
  Future<List<DeliveryPerson>> getPersonal() async {
    Response<List<dynamic>> response = await client.get("$readUrl/api/delivery_personell");
    if (response.statusCode != 200) return List.empty();
    return response.data!.map((e) => DeliveryPerson.fromMap(e)).toList();
  }
}