import 'package:clientapp/domain/model/Warehouse.dart';
import 'package:clientapp/domain/model/WarehouseType.dart';
import 'package:dio/dio.dart';

import '../../Env.dart';

abstract class WarehouseApi {
  Future<List<Warehouse>> getWarehouses();
  Future<Warehouse> getWarehouseById(int id);
  Future<void> addWarehouse(Warehouse warehouse);
  Future<void> updateWarehouse(Warehouse warehouse);
  Future<void> deleteWarehouse(Warehouse warehouse);

  Future<List<WarehouseType>> getTypes();
}

class WarehouseApiImpl implements WarehouseApi {
  final Dio client;

  WarehouseApiImpl({
    required this.client
  });

  String get readUrl => "${Env.prod_api_url}/warehousereadservice";
  String get url => "${Env.prod_api_url}/warehouseservice";

  @override
  Future<Warehouse> getWarehouseById(int id) async {
    Response<Map<String, dynamic>> response = await client.get("$readUrl/api/warehouse/$id");
    if (response.statusCode != 200) return Warehouse();
    return Warehouse.fromMap(response.data!);
  }

  @override
  Future<List<Warehouse>> getWarehouses() async {
    Response<List<dynamic>> response = await client.get("$readUrl/api/warehouses");
    if (response.statusCode != 200) return List.empty();
    return response.data!.map((w) => Warehouse.fromMap(w)).toList();
  }

  @override
  Future<void> addWarehouse(Warehouse warehouse) async {
    await client.post("$url/api/warehouse", data: warehouse.toRawJson());
  }

  @override
  Future<void> deleteWarehouse(Warehouse warehouse) async {
    await client.delete("$url/api/warehouse", data: warehouse.toRawJson());
  }

  @override
  Future<void> updateWarehouse(Warehouse warehouse) async {
    await client.patch("$url/api/warehouse", data: warehouse.toRawJson());
  }

  @override
  Future<List<WarehouseType>> getTypes() async {
    Response<List<dynamic>> response = await client.get("$readUrl/api/warehouse_types");
    if (response.statusCode != 200) return List.empty();
    return response.data!.map((t) => WarehouseType.fromMap(t)).toList(growable: true);
  }
}