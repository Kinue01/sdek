import 'package:clientapp/domain/model/User.dart';
import 'package:clientapp/domain/repository/current_user_repository.dart';

class SaveCurrentUserUseCase {
  CurrentUserRepository repository;

  SaveCurrentUserUseCase({
    required this.repository
  });

  Future<bool> exec(User user) async {
    return await repository.setCurrentUser(user);
  }
}