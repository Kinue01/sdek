import 'package:clientapp/domain/model/Transport.dart';
import 'package:clientapp/domain/model/TransportType.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TransportLocalStorage {
  Future<bool> saveTransport(Transport transport);
  Future<bool> saveTransports(List<Transport> transport);
  Future<Transport> getTransport(int id);
  Future<List<Transport>> getTransports();
  Future<Transport> getTransportByDriver(int driver);
  Future<bool> saveTransportByDriver(Transport transport, int driver);
}

class TransportLocalStorageImpl implements TransportLocalStorage {
  final SharedPreferencesAsync sharedPreferencesAsync;

  TransportLocalStorageImpl({
    required this.sharedPreferencesAsync
  });

  @override
  Future<Transport> getTransport(int id) async {
    final trans = await sharedPreferencesAsync.getString("TRANS_$id");
    return trans != null ? Transport.fromRawJson(trans) : Transport(transport_type: TransportType());
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

  @override
  Future<Transport> getTransportByDriver(int driver) async {
    final trans = await sharedPreferencesAsync.getString("TRANS_DRIVER_$driver");
    return trans != null ? Transport.fromRawJson(trans) : Transport(transport_type: TransportType());
  }

  @override
  Future<bool> saveTransportByDriver(Transport transport, int driver) async {
    final json = transport.toRawJson();
    await sharedPreferencesAsync.setString("TRANS_DRIVER_$driver", json);
    return true;
  }
}