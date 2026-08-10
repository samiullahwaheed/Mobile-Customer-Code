import 'package:loyalty_customer/widget/app_log/app_print.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  SocketService._privateConstructor();
  static final SocketService _instance = SocketService._privateConstructor();
  static SocketService get instance => _instance;

  IO.Socket? _socket;

  Function? _onConnectedCallback;

  bool get isConnected => _socket?.connected ?? false;

  /// 🔹 Initialize socket
  void initSocket({
    required String url,
    required String token,
    Function? onConnected,
  }) {
    // 🔥 IMPORTANT: dispose old socket
    if (_socket != null) {
      AppPrint.appLog('🔄 Disposing existing socket');
      _socket!
        ..offAny()
        ..disconnect()
        ..dispose();
      _socket = null;
    }

    _onConnectedCallback = onConnected;

    AppPrint.appLog('🔧 Initializing Socket');

    _socket = IO.io(
      url,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': token})
          .build(),
    );

    _registerDefaultListeners();
  }

  /// 🔹 Default listeners (ONLY ONCE)
  void _registerDefaultListeners() {
    _socket?.onConnect((_) {
      AppPrint.appLog('🟢 Socket CONNECTED');
      _onConnectedCallback?.call();
    });

    _socket?.onDisconnect((_) {
      AppPrint.appLog('🔴 Socket DISCONNECTED');
    });

    _socket?.onConnectError((error) {
      AppPrint.appError(error, title: '🔥 Socket CONNECT ERROR');
    });

    _socket?.onError((error) {
      AppPrint.appError(error, title: '⚠️ Socket ERROR');
    });
  }

  /// 🔹 Connect socket
  void connect() {
    if (_socket == null) {
      AppPrint.appError('Socket not initialized', title: 'Connect Failed');
      return;
    }

    if (_socket!.connected) {
      AppPrint.appLog('⚠️ Socket already connected');
      return;
    }

    AppPrint.appLog('🔌 Connecting socket...');
    _socket!.connect();
  }

  /// 🔹 Disconnect socket
  void disconnect() {
    if (_socket == null) return;

    AppPrint.appLog('🔌 Disconnecting socket...');
    _socket!
      ..offAny()
      ..disconnect();
  }

  /// 🔥 FIXED EVENT LISTENER
  void onEvent(String eventName, Function(dynamic data) callback) {
    if (_socket == null) return;

    // 🔥 THIS IS THE FIX
    _socket!.off(eventName);

    AppPrint.appLog('👂 Listening event → $eventName');

    _socket!.on(eventName, (data) {
      AppPrint.apiResponse(data, title: 'Socket Event → $eventName');
      callback(data);
    });
  }

  /// 🔹 Emit socket event
  void emit(String eventName, dynamic data) {
    if (_socket == null || !_socket!.connected) {
      AppPrint.appError('Socket not connected', title: 'Emit Failed');
      return;
    }

    AppPrint.appPrint(data, title: '📤 Emit → $eventName');
    _socket!.emit(eventName, data);
  }

  /// 🔹 Dispose socket completely
  void dispose() {
    if (_socket == null) return;

    AppPrint.appLog('🧹 Disposing socket');
    _socket!
      ..offAny()
      ..disconnect()
      ..dispose();

    _socket = null;
  }
}


