import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:substrate/substrate/provider/service/core/service.dart';
import 'package:http/retry.dart';
import 'package:polkadot_dart/polkadot_dart.dart';
import 'package:http/http.dart';

class SubstrateHttpService implements AppSubstrateSerivce {
  SubstrateHttpService(this.url,
      {RetryClient? client, this.defaultTimeOut = const Duration(seconds: 30)})
      : client = client ?? RetryClient(Client());

  @override
  final String url;
  final RetryClient client;
  final Duration defaultTimeOut;
  @override
  Future<BaseServiceResponse<T>> doRequest<T>(SubstrateRequestDetails params,
      {Duration? timeout}) async {
    final response = await client
        .post(params.toUri(url), headers: params.headers, body: params.body())
        .timeout(timeout ?? defaultTimeOut);
    return params.toResponse(response.bodyBytes, response.statusCode);
  }

  @override
  void close() {
    client.close();
  }
}
