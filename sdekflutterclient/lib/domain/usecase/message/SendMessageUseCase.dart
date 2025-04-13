import 'package:clientapp/domain/model/Message.dart';
import 'package:clientapp/domain/repository/message_repository.dart';

class SendMessageUseCase {
  MessageRepository repository;

  SendMessageUseCase({
    required this.repository
  });

  Future<bool> exec(Message msg) async {
    return await repository.sendMsg(msg);
  }
}