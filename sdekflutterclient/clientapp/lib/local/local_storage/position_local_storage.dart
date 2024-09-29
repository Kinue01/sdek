import 'package:clientapp/domain/model/Position.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PositionLocalStorage {
  Future<bool> savePositions(List<Position> poses);
  Future<bool> savePosition(Position pos);
  Future<Position> getPosition(int id);
  Future<List<Position>> getPositions();
}

class PositionLocalStorageImpl implements PositionLocalStorage {
  final SharedPreferencesAsync sharedPreferencesAsync;

  PositionLocalStorageImpl({
    required this.sharedPreferencesAsync
  });

  @override
  Future<Position> getPosition(int id) async {
    final pos = await sharedPreferencesAsync.getString("POS_$id");
    return pos != null ? Position.fromRawJson(pos) : Position();
  }

  @override
  Future<List<Position>> getPositions() async {
    final poses = await sharedPreferencesAsync.getStringList("POSES");
    return poses != null ? poses.map((e) => Position.fromRawJson(e)).toList() : [];
  }

  @override
  Future<bool> savePosition(Position pos) async {
    final key = pos.position_id;
    final posStr = pos.toRawJson();
    await sharedPreferencesAsync.setString("POS_$key", posStr);
    return true;
  }

  @override
  Future<bool> savePositions(List<Position> poses) async {
    await sharedPreferencesAsync.setStringList("POSES", poses.map((e) => e.toRawJson()).toList());
    return true;
  }
}