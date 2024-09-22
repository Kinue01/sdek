import 'package:clientapp/data/repository/user_data_repository.dart';
import 'package:clientapp/domain/model/User.dart';
import 'package:clientapp/domain/repository/user_repository.dart';
import 'package:uuid/uuid.dart';

class UserRepositoryImpl implements UserRepository {
  UserDataRepository repository;

  UserRepositoryImpl({
    required this.repository
  });

  @override
  Future<bool> addUser(User user) async {
    return await repository.addUser(user);
  }

  @override
  Future<bool> deleteUser(User user) async {
    return await repository.deleteUser(user);
  }

  @override
  Future<User> getUserById(Uuid uuid) async {
    return await repository.getUserById(uuid);
  }

  @override
  Future<List<User>> getUsers() async {
    return await repository.getUsers();
  }

  @override
  Future<bool> updateUser(User user) async {
    return await repository.updateUser(user);
  }
}