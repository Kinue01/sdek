import 'package:clientapp/domain/model/User.dart';
import 'package:clientapp/domain/repository/current_user_repository.dart';
import 'package:clientapp/local/local_storage/user_local_storage.dart';

class CurrentUserRepositoryImpl implements CurrentUserRepository {
  UserLocalStorage storage;

  CurrentUserRepositoryImpl({
    required this.storage
  });

  @override
  Future<User> getCurrentUser() async {
    return await storage.getCurrentUser();
  }

  @override
  Future<bool> setCurrentUser(User user) async {
    return await storage.saveCurrentUser(user);
  }
}