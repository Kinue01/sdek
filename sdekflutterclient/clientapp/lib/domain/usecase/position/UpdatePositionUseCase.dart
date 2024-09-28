import 'package:clientapp/domain/model/Position.dart';
import 'package:clientapp/domain/repository/position_repository.dart';

class UpdatePositionUseCase {
  PositionRepository repository;

  UpdatePositionUseCase({
    required this.repository
  });

  Future<bool> exec(Position pos) async {
    return await repository.updatePosition(pos);
  }
}