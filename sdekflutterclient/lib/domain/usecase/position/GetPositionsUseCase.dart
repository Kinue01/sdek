import 'package:clientapp/domain/model/Position.dart';
import 'package:clientapp/domain/repository/position_repository.dart';

class GetPositionsUseCase {
  PositionRepository repository;

  GetPositionsUseCase({
    required this.repository
  });

  Future<List<Position>> exec() async {
    return await repository.getPositions();
  }
}