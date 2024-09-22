import 'package:clientapp/domain/model/User.dart';
import 'package:uuid/uuid.dart';

abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<User> getUserById(Uuid uuid);
  Future<bool> addUser(User user);
  Future<bool> updateUser(User user);
  Future<bool> deleteUser(User user);
}