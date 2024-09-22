import 'package:clientapp/data/repository/position_data_repository.dart';
import 'package:clientapp/domain/model/Position.dart';
import 'package:clientapp/domain/repository/position_repository.dart';

class PositionRepositoryImpl implements PositionRepository {
  PositionDataRepository repository;

  PositionRepositoryImpl({
    required this.repository
  });

  @override
  Future<bool> addPosition(Position pos) async {
    return await repository.addPosition(pos);
  }

  @override
  Future<bool> deletePosition(Position pos) async {
    return await repository.deletePosition(pos);
  }

  @override
  Future<Position> getPositionById(int id) async {
    return await repository.getPositionById(id);
  }

  @override
  Future<List<Position>> getPositions() async {
    return await repository.getPositions();
  }

  @override
  Future<bool> updatePosition(Position pos) async {
    return await repository.updatePosition(pos);
  }
}