import 'package:clientapp/data/repository/user_data_repository.dart';
import 'package:clientapp/domain/model/User.dart';
import 'package:clientapp/domain/repository/user_repository.dart';
import 'package:clientapp/local/local_storage/user_local_storage.dart';
import '../../domain/model/Role.dart';

class UserRepositoryImpl implements UserRepository {
  UserDataRepository repository;
  UserLocalStorage userLocalStorage;

  UserRepositoryImpl({
    required this.repository,
    required this.userLocalStorage
  });

  @override
  Future<bool> addUser(User user) async {
    if (await repository.addUser(user)) {
      //await userLocalStorage.saveUser(user);
      return true;
    }
    else {
      return false;
    }
  }

  @override
  Future<bool> deleteUser(User user) async {
    if (await repository.deleteUser(user)) {
      //await userLocalStorage.saveUser(User(user_role: Role()));
      return true;
    }
    else {
      return false;
    }
  }

  @override
  Future<User> getUserById(String uuid) async {
    // final user = await userLocalStorage.getUser(uuid);
    // if (user.user_id != "") {
    //   return user;
    // }
    // else {
    //   final res = await repository.getUserById(uuid);
    //   if (res.user_id != "") {
    //     await userLocalStorage.saveUser(res);
    //   }
    //   return res;
    // }
    return await repository.getUserById(uuid);
  }

  @override
  Future<List<User>> getUsers() async {
    // final users = await userLocalStorage.getUsers();
    // if (users != []) {
    //   return users;
    // }
    // else {
    //   final res = await repository.getUsers();
    //   if (res != List.empty()) {
    //     await userLocalStorage.saveUsers(res);
    //   }
    //   return res;
    // }
    return await repository.getUsers();
  }

  @override
  Future<bool> updateUser(User user) async {
    if (await repository.updateUser(user)) {
      //await userLocalStorage.saveUser(user);
      return true;
    }
    else {
      return false;
    }
  }
}