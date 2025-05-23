import 'package:clientapp/domain/repository/user_repository.dart';

import '../../model/User.dart';

class DeleteUserUseCase {
  UserRepository repository;

  DeleteUserUseCase({
    required this.repository
  });

  Future<bool> exec(User user) async {
    return await repository.deleteUser(user);
  }
}