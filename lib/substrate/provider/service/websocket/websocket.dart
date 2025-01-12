import 'dart:async';
import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:substrate/app/error/exception/exception.dart';
import 'package:substrate/app/synchronized/basic_lock.dart';
import 'package:substrate/app/tools/func.dart';
import 'package:substrate/app/websocket/websocket.dart';
import 'package:substrate/substrate/provider/service/core/service.dart';
import 'package:polkadot_dart/polkadot_dart.dart';

class SocketRequestCompleter {
  SocketRequestCompleter(this.params, this.id);
  final Completer completer = Completer();
  final List<int> params;
  final int id;
}

class SubstrateWebsocketService extends WebSocketService
    implements AppSubstrateSerivce {
  SubstrateWebsocketService(
      {required super.url, this.defaultTimeOut = const Duration(seconds: 30)});

  final Duration defaultTimeOut;

  @override
  Future<BaseServiceResponse<T>> doRequest<T>(SubstrateRequestDetails params,
      {Duration? timeout}) async {
    final SocketRequestCompleter message =
        SocketRequestCompleter(params.body()!, params.requestID);
    final r = await addMessage(message, timeout ?? defaultTimeOut);
    return params.toResponse(r);
  }
}

enum SocketStatus { connect, disconnect, pending }

class WebSocketService {
  WebSocketService({required this.url});

  final String url;

  final _lock = SynchronizedLock();
  PlatformWebScoket? _socket;
  SocketStatus _status = SocketStatus.disconnect;
  StreamSubscription<String>? _subscription;

  bool get isConnected => _status == SocketStatus.connect;

  final Map<int, SocketRequestCompleter> _requests = {};
  void _add(List<int> message) {
    _socket?.sink(message);
  }

  void _onClose() {
    _status = SocketStatus.disconnect;
    _subscription?.cancel().catchError((e) {});
    _socket?.close();
    _subscription = null;
    _socket = null;
  }

  void close() => _onClose();

  Map<String, dynamic>? onMessge(String event) {
    final Map<String, dynamic> decode = StringUtils.toJson(event);
    if (decode.containsKey("id")) {
      final int id = int.parse(decode["id"]!.toString());
      final request = _requests.remove(id);
      request?.completer.complete(decode);
      if (request != null) {
        return null;
      }
    }
    return decode;
  }

  Future<void> connect() async {
    await _lock.synchronized(() async {
      if (_status != SocketStatus.disconnect) return;
      final result = await MethodUtils.call(() async {
        final socket = await PlatformWebScoket.connect(url);
        return socket;
      });
      if (result.hasResult) {
        _status = SocketStatus.connect;
        _socket = result.result;
        _subscription =
            _socket?.stream.cast<String>().listen(onMessge, onDone: _onClose);
      } else {
        _status = SocketStatus.disconnect;

        throw result.exception!;
      }
    });
  }

  Future<Map<String, dynamic>> addMessage(
      SocketRequestCompleter message, Duration timeout) async {
    try {
      return providerCaller(() async {
        _requests[message.id] = message;
        _add(message.params);
        final result = await message.completer.future.timeout(timeout);
        return result;
      }, message);
    } finally {
      _requests.remove(message.id);
    }
  }

  Future<Map<String, dynamic>> providerCaller(
      Future<Map<String, dynamic>> Function() t,
      SocketRequestCompleter param) async {
    Map<String, dynamic>? response;
    response = await _onException(t);
    return response;
  }

  Future<Map<String, dynamic>> _onException(
      Future<Map<String, dynamic>> Function() t) async {
    try {
      await connect().timeout(const Duration(seconds: 30));
      if (!isConnected) {
        throw const ApiProviderException(message: "api_http_timeout_error");
      }
      final response = await t();
      return response;
    } on ApiProviderException {
      rethrow;
    } on RPCError catch (e) {
      throw ApiProviderException(
          message: e.message,
          statusCode: e.errorCode,
          responseData: e.request,
          code: e.errorCode,
          requestPayload: e.details);
    } on TimeoutException {
      throw const ApiProviderException(message: "api_http_timeout_error");
    } on ArgumentError catch (e) {
      throw ApiProviderException(message: e.message.toString());
    } catch (e) {
      throw const ApiProviderException(message: "api_unknown_error");
    }
  }
}
