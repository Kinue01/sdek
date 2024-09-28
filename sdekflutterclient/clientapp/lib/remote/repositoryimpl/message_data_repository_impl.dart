import 'package:clientapp/data/repository/message_data_repository.dart';
import 'package:clientapp/domain/model/Message.dart';
import 'package:clientapp/remote/api/MessageApi.dart';

class MessageDataRepositoryImpl implements MessageDataRepository {
  MessageApi messageApi;

  MessageDataRepositoryImpl({
    required this.messageApi
  });

  @override
  Stream<Message> recvMsg() async* {
    await for (var item in messageApi.recvMsg()) {
      yield item;
    }
  }

  @override
  Future<bool> sendMsg(Message msg) async {
    return await messageApi.sendMsg(msg);
  }
}