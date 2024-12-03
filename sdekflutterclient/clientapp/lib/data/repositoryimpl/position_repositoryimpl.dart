import 'package:clientapp/data/repository/position_data_repository.dart';
import 'package:clientapp/domain/model/Position.dart';
import 'package:clientapp/domain/repository/position_repository.dart';
import 'package:clientapp/local/local_storage/position_local_storage.dart';

class PositionRepositoryImpl implements PositionRepository {
  PositionDataRepository repository;
  PositionLocalStorage positionLocalStorage;

  PositionRepositoryImpl({
    required this.repository,
    required this.positionLocalStorage
  });

  @override
  Future<bool> addPosition(Position pos) async {
    if (await repository.addPosition(pos)) {
      //await positionLocalStorage.savePosition(pos);
      return true;
    }
    else {
      return false;
    }
  }

  @override
  Future<bool> deletePosition(Position pos) async {
    if (await repository.deletePosition(pos)) {
      //await positionLocalStorage.savePosition(Position());
      return true;
    }
    else {
      return false;
    }
  }

  @override
  Future<Position> getPositionById(int id) async {
    // final pos = await positionLocalStorage.getPosition(id);
    // if (pos.position_id != 0) {
    //   return pos;
    // }
    // else {
    //   final res = await repository.getPositionById(id);
    //   if (res.position_id != 0) {
    //     await positionLocalStorage.savePosition(res);
    //   }
    //   return res;
    // }
    return await repository.getPositionById(id);
  }

  @override
  Future<List<Position>> getPositions() async {
    // final poses = await positionLocalStorage.getPositions();
    // if (poses != []) {
    //   return poses;
    // }
    // else {
    //   final res = await repository.getPositions();
    //   if (res != List.empty()) {
    //     await positionLocalStorage.savePositions(res);
    //   }
    //   return res;
    // }
    return await repository.getPositions();
  }

  @override
  Future<bool> updatePosition(Position pos) async {
    if (await repository.updatePosition(pos)) {
      //await positionLocalStorage.savePosition(pos);
      return true;
    }
    else {
      return false;
    }
  }
}