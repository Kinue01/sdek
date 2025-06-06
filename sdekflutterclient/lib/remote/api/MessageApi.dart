import 'package:web_socket_channel/web_socket_channel.dart';

import '../../Env.dart';
import '../../domain/model/Message.dart';

abstract class MessageApi {
  Future<bool> sendMsg(Message msg);
  Stream<Message> recvMsg();
}

class MessageApiImpl implements MessageApi {
  WebSocketChannel ws = WebSocketChannel.connect(Uri.parse("${Env.prod_ws}/userservice"));
  
  @override
  Stream<Message> recvMsg() async* {
    await for (var item in ws.stream) {
      yield Message.fromMap(item);
    }
  }

  @override
  Future<bool> sendMsg(Message msg) async {
    ws.sink.add(msg.toRawJson());
    return true;
  }
}