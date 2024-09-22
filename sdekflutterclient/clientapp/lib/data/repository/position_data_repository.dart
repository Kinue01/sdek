import 'package:clientapp/domain/model/Position.dart';

abstract class PositionDataRepository {
  Future<List<Position>> getPositions();
  Future<Position> getPositionById(int id);
  Future<bool> addPosition(Position pos);
  Future<bool> updatePosition(Position pos);
  Future<bool> deletePosition(Position pos);
}