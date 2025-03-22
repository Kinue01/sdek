import 'package:web_socket_channel/web_socket_channel.dart';

class TrackPackageController {
  final channel = WebSocketChannel.connect(Uri.parse("http://localhost/transportreadservice/api/transport_pos"));
}