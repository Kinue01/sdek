import 'package:clientapp/domain/model/User.dart';
import 'package:clientapp/domain/repository/user_repository.dart';
import 'package:uuid/uuid.dart';

class GetUserByIdUseCase {
  UserRepository repository;

  GetUserByIdUseCase({
    required this.repository
  });

  Future<User> exec(Uuid uuid) async {
    return await repository.getUserById(uuid);
  }
}