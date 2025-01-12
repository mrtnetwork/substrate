import 'dart:async';
import 'dart:typed_data';
// import 'package:mrt_native_support/web/mrt_native_web.dart';
// import 'package:mrt_wallet/app/dev/logging.dart';
// import 'package:mrt_wallet/app/error/exception/exception.dart';
// import 'package:mrt_wallet/app/websocket/websocket.dart';
import 'package:substrate/app/error/exception/exception.dart';
import 'package:substrate/app/websocket/core/core.dart';
import 'dart:js_interop';

class _WebsocketConst {
  static const String messageEvent = "message";
  static const String closeEvent = "close";
  static const String openEvent = "open";
}

Future<PlatformWebScoket> connectSoc(String url,
        {List<String>? protocols}) async =>
    await WebsocketWeb.connect(url);

class WebsocketWeb implements PlatformWebScoket {
  final JSWebSocket _socket;
  late final StreamController<dynamic> _streamController =
      StreamController<dynamic>()..onCancel = _onCloseStream;
  void _onCloseStream() {
    if (!_socket.isClosed) {
      _socket.close(1000, "closed by client.");
    }
    _onOpen?.cancel();
    _onMessage?.cancel();
    _onClose?.cancel();
    _onClose = null;
    _onMessage = null;
    _onOpen = null;
  }

  Completer<WebsocketWeb>? _connectedCompleter = Completer<WebsocketWeb>();
  StreamSubscription<dynamic>? _onOpen;
  StreamSubscription<dynamic>? _onClose;
  StreamSubscription<dynamic>? _onMessage;
  WebsocketWeb._(this._socket) {
    _onOpen = _socket.stream(_WebsocketConst.openEvent).listen((event) {
      _connectedCompleter?.complete(this);
      _connectedCompleter = null;
      _onOpen?.cancel();
      _onOpen = null;
    });

    _onMessage = _socket.stream(_WebsocketConst.messageEvent).listen((event) {
      _streamController.add(event);
    });

    _onClose = _socket.stream(_WebsocketConst.closeEvent).listen((event) {
      _streamController.close();
      _connectedCompleter?.completeError(
          const ApiProviderException(message: "api_http_client_error"));
      _connectedCompleter = null;
    });
  }

  @override
  void close() {
    _streamController.close();
  }

  @override
  bool get isConnected => _socket.isOpen;
  @override
  Stream<dynamic> get stream => _streamController.stream;

  static Future<WebsocketWeb> connect(String url,
      {List<String> protocols = const []}) async {
    final socket =
        WebsocketWeb._(JSWebSocket.create(url, protocols: protocols));
    try {
      return await socket._connectedCompleter!.future;
    } on ApiProviderException {
      rethrow;
    } catch (_) {
      socket.close();
      rethrow;
    }
  }

  @override
  void sink(List<int> message) {
    _socket.send_(message);
  }
}

@JS("WebSocket")
extension type JSWebSocket._(JSObject _) implements JSObject, WebEventStream {
  external factory JSWebSocket(String url, [JSArray<JSString>? protocols]);
  factory JSWebSocket.create(String url, {List<String> protocols = const []}) {
    return JSWebSocket(url, protocols.map((e) => e.toJS).toList().toJS);
  }

  external int get readyState;
  external String get url;
  external void close([int? code, String? reason]);
  external void send(JSAny data);

  bool get isOpen => readyState == 1;
  bool get isClosed => readyState == 3;

  void send_(List<int> bytes) {
    final data = Uint8List.fromList(bytes).buffer.toJS;
    send(data);
  }
}
@JS("Event")
extension type WebEvent._(JSObject _) implements EventInit {
  external factory WebEvent(String? type, EventInit? options);
  external String? get type;
}
@JS()
extension type EventInit._(JSObject _) implements JSObject {
  external bool? get bubbles;
  external bool? get cancelable;
  external bool? get composed;
  external JSAny? get detail;
  external set bubbles(bool? bubbles);
  external set cancelable(bool? cancelable);
  external set composed(bool? composed);
  external set detail(JSAny? detail);
  external set data(JSAny? data);
  external factory EventInit(
      {bool? bubbles,
      bool? cancelable,
      bool? composed,
      JSAny? detail,
      JSAny? data});

  List<int>? detailBytes() {
    try {
      return List<int>.from(detail.dartify() as List);
    } catch (e) {
      return null;
    }
  }
}
@JS("Event")
extension type MessageEvent._(JSObject _) implements WebEvent {
  external factory MessageEvent();
  external JSAny? get data;
}
extension type WebEventStream._(JSObject _) {
  @JS("addEventListener")
  external void addEventListener(String type, JSFunction callback);
  @JS("removeEventListener")
  external void removeEventListener(String type, JSFunction callback);

  external void dispatchEvent(WebEvent event);

  Stream<T> stream<T>(String type) {
    final StreamController<T> controller = StreamController();
    final callback = (MessageEvent event) {
      controller.add(event.data?.dartify() as T);
    }.toJS;
    controller.onCancel = () {
      removeEventListener(type, callback);
    };
    addEventListener(type, callback);

    return controller.stream;
  }

  Stream<JSAny> streamObject<T>(String type) {
    final StreamController<JSAny> controller = StreamController();
    final callback = (JSAny content) {
      controller.add(content);
    }.toJS;
    controller.onCancel = () {
      removeEventListener(type, callback);
    };
    addEventListener(type, callback);

    return controller.stream;
  }
}
