import 'package:clientapp/domain/model/TransportType.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TransportTypeLocalStorage {
  Future<bool> saveTransportTypes(List<TransportType> roles);
  Future<bool> saveTransportType(TransportType role);
  Future<List<TransportType>> getTransportTypes();
  Future<TransportType> getTransportType(int id);
}

class TransportTypeLocalStorageImpl implements TransportTypeLocalStorage {
  final SharedPreferencesAsync sharedPreferencesAsync;

  TransportTypeLocalStorageImpl({
    required this.sharedPreferencesAsync
  });

  @override
  Future<TransportType> getTransportType(int id) async {
    final type = await sharedPreferencesAsync.getString("TRANS_TYPE_$id");
    return type != null ? TransportType.fromRawJson(type) : TransportType();
  }

  @override
  Future<List<TransportType>> getTransportTypes() async {
    final types = await sharedPreferencesAsync.getStringList("TRANS_TYPES");
    return types != null ? types.map((e) => TransportType.fromRawJson(e)).toList() : [];
  }

  @override
  Future<bool> saveTransportType(TransportType role) async {
    final key = role.type_id;
    final json = role.toRawJson();
    await sharedPreferencesAsync.setString("TRANS_TYPE_$key", json);
    return true;
  }

  @override
  Future<bool> saveTransportTypes(List<TransportType> roles) async {
    await sharedPreferencesAsync.setStringList("TRANS_TYPES", roles.map((e) => e.toRawJson()).toList());
    return true;
  }
}