import 'package:web_socket_channel/web_socket_channel.dart';

class TrackPackageController {
  final channel = WebSocketChannel.connect(Uri.parse("ws://localhost:8080/transportreadservice/api/transport_pos"));
}