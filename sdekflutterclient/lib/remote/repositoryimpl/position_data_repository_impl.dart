import 'package:clientapp/data/repository/position_data_repository.dart';
import 'package:clientapp/domain/model/Position.dart';
import 'package:clientapp/remote/api/position_api.dart';

class PositionDataRepositoryImpl implements PositionDataRepository {
  PositionApi positionApi;

  PositionDataRepositoryImpl({
    required this.positionApi
  });

  @override
  Future<bool> addPosition(Position pos) async {
    return await positionApi.addPosition(pos);
  }

  @override
  Future<bool> deletePosition(Position pos) async {
    return await positionApi.deletePosition(pos);
  }

  @override
  Future<Position> getPositionById(int id) async {
    return await positionApi.getPositionById(id);
  }

  @override
  Future<List<Position>> getPositions() async {
    return await positionApi.getPositions();
  }

  @override
  Future<bool> updatePosition(Position pos) async {
    return await positionApi.updatePosition(pos);
  }
}