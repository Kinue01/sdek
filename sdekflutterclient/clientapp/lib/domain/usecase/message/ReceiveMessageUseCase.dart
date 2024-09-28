import 'package:clientapp/domain/model/Message.dart';
import 'package:clientapp/domain/repository/message_repository.dart';

class ReceiveMessageUseCase {
  MessageRepository repository;

  ReceiveMessageUseCase({
    required this.repository
  });

  Stream<Message> exec() async* {
    await for (var item in repository.recvMsg()) {
      yield item;
    }
  }
}