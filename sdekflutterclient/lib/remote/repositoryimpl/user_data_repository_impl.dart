import 'package:clientapp/data/repository/user_data_repository.dart';
import 'package:clientapp/domain/model/User.dart';
import 'package:clientapp/remote/api/user_api.dart';

class UserDataRepositoryImpl implements UserDataRepository {
  UserApi userApi;

  UserDataRepositoryImpl({
    required this.userApi
  });

  @override
  Future<bool> addUser(User user) async {
    return await userApi.addUser(user);
  }

  @override
  Future<bool> deleteUser(User user) async {
    return await userApi.deleteUser(user);
  }

  @override
  Future<User> getUserById(String uuid) async {
    return await userApi.getUserById(uuid);
  }

  @override
  Future<List<User>> getUsers() async {
    return await userApi.getUsers();
  }

  @override
  Future<bool> updateUser(User user) async {
    return await userApi.updateUser(user);
  }
}