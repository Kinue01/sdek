import '../model/Message.dart';

abstract class MessageRepository {
  Future<bool> sendMsg(Message msg);
  Stream<Message> recvMsg();
}