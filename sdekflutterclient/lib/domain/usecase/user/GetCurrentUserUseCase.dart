import 'package:clientapp/domain/model/User.dart';
import 'package:clientapp/domain/repository/current_user_repository.dart';

class GetCurrentUserUseCase {
  CurrentUserRepository repository;

  GetCurrentUserUseCase({
    required this.repository
  });

  Future<User> exec() async {
    return await repository.getCurrentUser();
  }
}