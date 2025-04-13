import 'package:clientapp/domain/model/User.dart';
import 'package:clientapp/domain/repository/user_repository.dart';

class AddUserUseCase {
  UserRepository repository;

  AddUserUseCase({
    required this.repository
  });

  Future<bool> exec(User user) async {
    return await repository.addUser(user);
  }
}