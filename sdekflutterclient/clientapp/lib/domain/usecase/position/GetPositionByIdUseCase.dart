import 'package:clientapp/domain/model/Position.dart';
import 'package:clientapp/domain/repository/position_repository.dart';

class GetUserByIdUseCase {
  PositionRepository repository;

  GetUserByIdUseCase({
    required this.repository
  });

  Future<Position> exec(int id) async {
    return await repository.getPositionById(id);
  }
}