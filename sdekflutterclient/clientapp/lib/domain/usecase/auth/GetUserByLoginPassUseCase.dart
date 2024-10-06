import 'package:clientapp/domain/model/User.dart';
import 'package:clientapp/domain/repository/authorisation_repository.dart';

class GetUserByLoginPassUseCase {
  final AuthorisationOauthRepository repository;

  GetUserByLoginPassUseCase({
    required this.repository
  });

  Future<User> exec(User user) async {
    return await repository.getUserByLoginPass(user);
  }
}