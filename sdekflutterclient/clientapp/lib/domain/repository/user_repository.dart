import 'package:clientapp/domain/model/User.dart';

abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<User> getUserById(String uuid);
  Future<bool> addUser(User user);
  Future<bool> updateUser(User user);
  Future<bool> deleteUser(User user);
}