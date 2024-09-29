import 'package:clientapp/domain/model/Employee.dart';
import 'package:clientapp/domain/model/Position.dart';
import 'package:clientapp/domain/model/Role.dart';
import 'package:clientapp/domain/model/Transport.dart';
import 'package:clientapp/domain/model/TransportType.dart';
import 'package:clientapp/domain/model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TransportLocalStorage {
  Future<bool> saveTransport(Transport transport);
  Future<bool> saveTransports(List<Transport> transport);
  Future<Transport> getTransport(int id);
  Future<List<Transport>> getTransports();
}

class TransportLocalStorageImpl implements TransportLocalStorage {
  final SharedPreferencesAsync sharedPreferencesAsync;

  TransportLocalStorageImpl({
    required this.sharedPreferencesAsync
  });

  @override
  Future<Transport> getTransport(int id) async {
    final trans = await sharedPreferencesAsync.getString("TRANS_$id");
    return trans != null ? Transport.fromRawJson(trans) : Transport(transport_type: TransportType(), transport_driver: Employee(employee_position: Position(), employee_user: User(user_role: Role())));
  }

  @override
  Future<List<Transport>> getTransports() async {
    final trans = await sharedPreferencesAsync.getStringList("TRANSES");
    return trans != null ? trans.map((e) => Transport.fromRawJson(e)).toList() : [];
  }

  @override
  Future<bool> saveTransport(Transport transport) async {
    final key = transport.transport_id;
    final json = transport.toRawJson();
    await sharedPreferencesAsync.setString("TRANS_$key", json);
    return true;
  }

  @override
  Future<bool> saveTransports(List<Transport> transport) async {
    await sharedPreferencesAsync.setStringList("TRANSES", transport.map((e) => e.toRawJson()).toList());
    return true;
  }
}