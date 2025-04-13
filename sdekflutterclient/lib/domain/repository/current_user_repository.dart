import 'package:clientapp/domain/model/User.dart';

abstract class CurrentUserRepository {
  Future<User> getCurrentUser();
  Future<bool> setCurrentUser(User user);
}