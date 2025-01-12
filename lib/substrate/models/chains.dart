import 'package:blockchain_utils/helper/helper.dart';
import 'package:substrate/future/constant/constant.dart';

class NetworkInfo {
  final String name;
  final String networkType;
  final Specs? specs;
  final Set<RpcEndpoint> rpcEndpoints;
  NetworkInfo copyWith(
      {Set<RpcEndpoint>? rpcEndpoints,
      Specs? specs,
      String? networkType,
      String? name}) {
    return NetworkInfo(
        name: name ?? this.name,
        networkType: networkType ?? this.networkType,
        rpcEndpoints: rpcEndpoints ?? this.rpcEndpoints,
        specs: specs ?? this.specs);
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "network_type": networkType,
      "specs": specs?.toJson(),
      "rpc_endpoints": rpcEndpoints.map((e) => e.toJson()).toList()
    };
  }

  NetworkInfo(
      {required this.name,
      this.networkType = '',
      this.specs,
      Set<RpcEndpoint> rpcEndpoints = const {}})
      : rpcEndpoints = rpcEndpoints.toImutableSet;

  factory NetworkInfo.fromJson(Map<String, dynamic> json) {
    return NetworkInfo(
        name: json['name'],
        networkType: json['network_type'],
        specs: json["specs"] == null ? null : Specs.fromJson(json['specs']),
        rpcEndpoints: (json['rpc_endpoints'] as List<dynamic>)
            .map((e) => RpcEndpoint.fromJson(e))
            .toImutableSet);
  }

  @override
  operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! NetworkInfo) return false;
    if (other.name == name) return true;
    return false;
  }

  @override
  int get hashCode => name.hashCode;
}

class Specs {
  final int decimals;
  final String token;
  final int? ss58Format;

  Specs({
    required this.decimals,
    required this.token,
    required this.ss58Format,
  });
  Map<String, dynamic> toJson() {
    return {"decimals": decimals, "token": token, "ss58_format": ss58Format};
  }

  factory Specs.fromJson(Map<String, dynamic> json) {
    return Specs(
        decimals: json['decimals'],
        token: json['token'],
        ss58Format: json['ss58_format']);
  }
}

class RpcEndpoint {
  final String name;
  final String url;
  const RpcEndpoint({required this.name, required this.url});
  factory RpcEndpoint.fromJson(Map<String, dynamic> json) {
    return RpcEndpoint(name: json['name'], url: json['url']);
  }
  Map<String, dynamic> toJson() {
    return {"name": name, "url": url};
  }

  @override
  operator ==(other) {
    if (identical(this, other)) return true;
    if (other is! RpcEndpoint) return false;
    if (other.url == url) return true;
    return false;
  }

  @override
  int get hashCode => url.hashCode;
}

class LatestChain {
  final NetworkInfo network;
  final RpcEndpoint endpoint;
  final int metadataVersion;
  const LatestChain(
      {required this.network,
      required this.endpoint,
      this.metadataVersion = APPConst.defaultMetadataVersion});
  factory LatestChain.fromJson(Map<String, dynamic> json) {
    return LatestChain(
        network: NetworkInfo.fromJson(json['network']),
        endpoint: RpcEndpoint.fromJson(json["endpoint"]),
        metadataVersion: json["metadataVersion"]);
  }
  Map<String, dynamic> toJson() {
    return {
      "network": network.toJson(),
      "endpoint": endpoint.toJson(),
      "metadataVersion": metadataVersion
    };
  }

  LatestChain copyWith(
      {NetworkInfo? network, RpcEndpoint? endpoint, int? metadataVersion}) {
    return LatestChain(
        network: network ?? this.network,
        endpoint: endpoint ?? this.endpoint,
        metadataVersion: metadataVersion ?? this.metadataVersion);
  }
}
