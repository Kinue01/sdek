import 'package:clientapp/domain/model/Position.dart';
import 'package:clientapp/domain/repository/position_repository.dart';

class AddUserUseCase {
  PositionRepository repository;

  AddUserUseCase({
    required this.repository
  });

  Future<bool> exec(Position pos) async {
    return await repository.addPosition(pos);
  }
}