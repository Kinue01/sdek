import 'package:clientapp/domain/model/User.dart';
import 'package:clientapp/domain/repository/user_repository.dart';

class GetUsersUseCase {
  UserRepository repository;

  GetUsersUseCase({
    required this.repository
  });

  Future<List<User>> exec() async {
    return await repository.getUsers();
  }
}