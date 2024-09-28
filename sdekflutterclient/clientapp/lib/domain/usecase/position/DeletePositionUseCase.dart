import 'package:clientapp/domain/model/Position.dart';
import 'package:clientapp/domain/repository/position_repository.dart';

class DeletePositionUseCase {
  PositionRepository repository;

  DeletePositionUseCase({
    required this.repository
  });

  Future<bool> exec(Position pos) async {
    return await repository.deletePosition(pos);
  }
}