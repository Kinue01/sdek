import 'package:clientapp/data/repository/message_data_repository.dart';
import 'package:clientapp/domain/model/Message.dart';
import 'package:clientapp/domain/repository/message_repository.dart';

class MessageRepositoryImpl implements MessageRepository {
  MessageDataRepository repository;

  MessageRepositoryImpl({
    required this.repository
  });

  @override
  Stream<Message> recvMsg() async* {
    await for (var item in repository.recvMsg()) {
      yield item;
    }
  }

  @override
  Future<bool> sendMsg(Message msg) async {
    return await repository.sendMsg(msg);
  }
}