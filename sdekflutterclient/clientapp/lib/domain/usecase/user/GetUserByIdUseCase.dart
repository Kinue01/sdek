import 'package:clientapp/domain/model/User.dart';
import 'package:clientapp/domain/repository/user_repository.dart';

class GetUserByIdUseCase {
  UserRepository repository;

  GetUserByIdUseCase({
    required this.repository
  });

  Future<User> exec(String uuid) async {
    return await repository.getUserById(uuid);
  }
}