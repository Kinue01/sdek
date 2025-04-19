import 'package:clientapp/domain/model/Warehouse.dart';
import 'package:dio/dio.dart';

abstract class WarehouseApi {
  Future<List<Warehouse>> getWarehouses();
  Future<Warehouse> getWarehouseById(int id);
}

class WarehouseApiImpl implements WarehouseApi {
  final Dio client;

  WarehouseApiImpl({
    required this.client
  });

  String get readUrl => "http://localhost:8080/warehousereadservice";

  @override
  Future<Warehouse> getWarehouseById(int id) {
    // TODO: implement getWarehouseById
    throw UnimplementedError();
  }

  @override
  Future<List<Warehouse>> getWarehouses() async {
    Response<List<dynamic>> response = await client.get("$readUrl/api/warehouses");
    if (response.statusCode != 200) return List.empty();
    return response.data!.map((w) => Warehouse.fromMap(w)).toList();
  }
}