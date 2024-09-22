import '../model/Message.dart';

abstract class MessageRepository {
  Future<bool> sendMsg(Message msg);
  Future<Message> recvMsg();
}