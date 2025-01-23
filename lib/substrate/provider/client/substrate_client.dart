import 'package:blockchain_utils/exception/exceptions.dart';
import 'package:blockchain_utils/helper/helper.dart';
import 'package:blockchain_utils/utils/utils.dart';
import 'package:substrate/app/error/exception.dart';
import 'package:substrate/future/constant/constant.dart';
import 'package:substrate/substrate/provider/client/models/block_with_era.dart';
import 'package:substrate/substrate/provider/methods/abi.dart';
import 'package:substrate/substrate/provider/service/core/service.dart';
import 'package:polkadot_dart/polkadot_dart.dart';

class RuntimeMetadataVersionInfo {
  final MetadataApi metadata;
  final RuntimeVersion runtimeVersion;
  final MetadataInfo metadataInfo;
  final int version;
  RuntimeMetadataVersionInfo({required this.metadata})
      : version = metadata.metadata.version,
        runtimeVersion = metadata.runtimeVersion(),
        metadataInfo = metadata.metadata.palletsInfos();
}

class RuntimeMetadataInfo {
  final List<RuntimeMetadataVersionInfo> supportedMetadata;
  RuntimeMetadataVersionInfo _metadata;
  RuntimeMetadataVersionInfo get metadata => _metadata;
  int get version => metadata.version;
  late final List<int> supportedVersions =
      supportedMetadata.map((e) => e.version).immutable;
  RuntimeMetadataInfo._({
    required RuntimeMetadataVersionInfo metadata,
    required List<RuntimeMetadataVersionInfo> supportedMetadata,
  })  : supportedMetadata = supportedMetadata.immutable,
        _metadata = metadata;
  factory RuntimeMetadataInfo({
    int version = APPConst.defaultMetadataVersion,
    required List<RuntimeMetadataVersionInfo> supportedMetadata,
  }) {
    if (supportedMetadata.isEmpty) {
      throw const SubstrateAppException("unsuported_metadata");
    }
    RuntimeMetadataVersionInfo? metadata =
        supportedMetadata.firstWhereNullable((e) => e.version == version);
    if (metadata == null && version != APPConst.defaultMetadataVersion) {
      metadata ??= supportedMetadata.firstWhereNullable(
          (e) => e.version == APPConst.defaultMetadataVersion);
    }
    metadata ??= supportedMetadata.first;
    return RuntimeMetadataInfo._(
        metadata: metadata, supportedMetadata: supportedMetadata);
  }
  void switchMetadata(int version) {
    if (version == _metadata.version) return;
    final v = supportedMetadata.firstWhereNullable((e) => e.version == version);
    if (v != null) {
      _metadata = v;
    }
  }
}

class SubstrateClient {
  final SubstrateProvider provider;
  SubstrateClient({required this.provider});
  AppSubstrateSerivce get service => provider.rpc as AppSubstrateSerivce;
  RuntimeMetadataInfo? _api;
  RuntimeMetadataInfo get apiInfo => _api!;
  MetadataApi get api => _api!.metadata.metadata;
  bool get inited => _api != null && _genesis != null;
  SubstrateBlockHash? _genesis;
  SubstrateBlockHash get genesisBlock => _genesis!;

  Future<int> getNonce(SubstrateAddress address) async {
    final storage = await api.getAccount(address: address, rpc: provider);
    return storage.nonce;
  }

  Future<SubstrateBlockHash> getBlockHash({int? atNumber}) async {
    final blockHash = await provider
        .request(SubstrateRequestChainGetBlockHash(number: atNumber));
    if (blockHash == null) {
      throw UnimplementedError();
    }
    return SubstrateBlockHash.hash(blockHash);
  }

  Future<SubstrateBlockHash> getFinalizBlock({int? atNumber}) async {
    final blockHash = await provider
        .request(const SubstrateRequestChainChainGetFinalizedHead());
    return SubstrateBlockHash.hash(blockHash);
  }

  Future<SubstrateHeaderResponse> getBlockHeader({String? atBlockHash}) async {
    final header = await provider
        .request(SubstrateRequestChainChainGetHeader(atBlockHash: atBlockHash));
    return header;
  }

  Future<String> broadcastTransaction(Extrinsic extrinsic) async {
    return await provider.request(
        SubstrateRequestAuthorSubmitExtrinsic(extrinsic.toHex(prefix: "0x")));
  }

  Future<String> broadcastSerializedExtrinsic(String extrinsic) async {
    return await provider
        .request(SubstrateRequestAuthorSubmitExtrinsic(extrinsic));
  }

  Future<MortalEra> getBlockEra(String blockHash) async {
    final header = await getBlockHeader(atBlockHash: blockHash);
    return header.toMortalEra(period: 150);
  }

  Future<BlockHashWithEra> blockWithEra() async {
    final finalizBlock = await getFinalizBlock();
    final blockHash = finalizBlock.toHex();
    final era = await getBlockEra(blockHash);
    return BlockHashWithEra(hash: blockHash, era: era);
  }

  Future<RuntimeMetadataInfo?> getLastestVersionedMetadata(
      int metadataVersion) async {
    List<int> versions = [];
    try {
      versions = await provider
          .request(const SubstrateRequestRuntimeMetadataGetVersions());
    } on RPCError catch (_) {}
    List<RuntimeMetadataVersionInfo> apis = [];
    for (final i in versions) {
      if (!MetadataConstant.supportedMetadataVersion.contains(i) &&
          i != maxUint32) {
        continue;
      }
      try {
        final metadata = await provider.request(SubstrateGetApiAt(i));
        if (metadata == null) continue;
        apis.add(RuntimeMetadataVersionInfo(metadata: metadata));
      } on RPCError {
        if (apis.isEmpty) rethrow;
      } on ApiProviderException {
        if (apis.isEmpty) rethrow;
      } catch (_) {}
    }
    if (apis.isEmpty) {
      final metadata = await provider.request(const SubstrateGetStateApi());
      try {
        if (metadata != null) {
          apis.add(RuntimeMetadataVersionInfo(metadata: metadata));
        }
      } catch (_) {}
    }
    if (apis.isEmpty) {
      return null;
    }
    return RuntimeMetadataInfo(
        supportedMetadata: apis, version: metadataVersion);
  }

  Future<SubstrateBlockHash> loadGenesis() async {
    if (_genesis != null) return _genesis!;
    final genesis = await provider
        .request(const SubstrateRequestChainGetBlockHash<String>(number: 0));
    _genesis = SubstrateBlockHash.hash(genesis);
    return _genesis!;
  }

  Future<bool> init(int metaataVersion) async {
    _api = await getLastestVersionedMetadata(metaataVersion);
    await loadGenesis();
    return _api != null && _genesis != null;
  }
}
