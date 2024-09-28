import '../../domain/model/Message.dart';

abstract class MessageDataRepository {
  Future<bool> sendMsg(Message msg);
  Stream<Message> recvMsg();
}