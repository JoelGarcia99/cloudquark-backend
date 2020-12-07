import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Socket {
  final String host = DotEnv().env['HOST'];
  final String port = DotEnv().env['PORT'];
  IO.Socket socket;

  Socket(){
    this.socket = IO.io('$host:$port');
  }
}