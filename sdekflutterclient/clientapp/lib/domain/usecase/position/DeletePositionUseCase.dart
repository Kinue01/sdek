import 'package:clientapp/domain/model/Position.dart';
import 'package:clientapp/domain/repository/position_repository.dart';

class DeleteUserUseCase {
  PositionRepository repository;

  DeleteUserUseCase({
    required this.repository
  });

  Future<bool> exec(Position pos) async {
    return await repository.deletePosition(pos);
  }
}