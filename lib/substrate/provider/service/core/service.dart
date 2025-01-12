import 'package:substrate/substrate/provider/service/http/service.dart';
import 'package:substrate/substrate/provider/service/websocket/websocket.dart';
import 'package:polkadot_dart/polkadot_dart.dart';

abstract class AppSubstrateSerivce with SubstrateServiceProvider {
  String get url;
  void close();
  const AppSubstrateSerivce();
  factory AppSubstrateSerivce.fromUri(String url) {
    if (url.startsWith("http")) {
      return SubstrateHttpService(url);
    }
    return SubstrateWebsocketService(url: url);
  }
}
