import 'package:blockchain_utils/helper/helper.dart';
import 'package:substrate/app/error/exception.dart';
import 'package:substrate/future/forms/models/lookup_fields.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:substrate/substrate/models/chains.dart';
import 'package:substrate/substrate/provider/client/substrate_client.dart';
import 'package:substrate/substrate/provider/service/service.dart';
import 'package:polkadot_dart/polkadot_dart.dart';

class SubstrateApi {
  // MetadataInfo _metadataInfo;
  MetadataInfo get metadataInfo => runtimeMetadata.metadata.metadataInfo;
  final SubstrateClient client;
  RuntimeVersion get runtimeVersion => runtimeMetadata.metadata.runtimeVersion;
  NetworkInfo get networkInfo => _chain.network;
  RpcEndpoint get endpoint => _chain.endpoint;
  LatestChain _chain;
  LatestChain get chain => _chain;
  final String gnesisBlock;
  final String name;
  MetadataApi get api => client.api;
  RuntimeMetadataInfo get runtimeMetadata => client.apiInfo;
  bool get supportRuntimeApi => api.metadata.supportRuntimeApi;
  SubstrateApi._(
      {required this.client,
      required this.gnesisBlock,
      required this.name,
      required LatestChain chain})
      : _chain = chain;
  static Future<SubstrateApi> init(LatestChain chain) async {
    final provider =
        SubstrateProvider(AppSubstrateSerivce.fromUri(chain.endpoint.url));
    final client = SubstrateClient(provider: provider);
    await client.init(chain.metadataVersion);
    if (!client.inited) {
      throw const SubstrateAppException("unsuported_metadata");
    }
    final runtime = client.api.runtimeVersion();
    return SubstrateApi._(
        client: client,
        gnesisBlock: client.genesisBlock.toHex(),
        name: runtime.specName.camelCase,
        chain: chain.copyWith(metadataVersion: client.apiInfo.version));
  }

  MetadataTypeInfo getTypeInfo(Si1Variant variant) {
    MetadataTypeInfo info = variant.typeInfo(api.registry, 0);
    info = info.copyWith(name: info.name ?? variant.name);
    return info;
  }

  List<PalletInfo> constantPallets() {
    return metadataInfo.pallets.where((e) => e.contants != null).toList();
  }

  List<PalletInfo> callPallets() {
    return metadataInfo.pallets.where((e) => e.calls != null).toList();
  }

  List<PalletInfo> storagePallets() {
    return metadataInfo.pallets.where((e) => e.storage != null).toList();
  }

  StorageInfo? getAccountInfoStorageKey() {
    final system = metadataInfo.pallets
        .firstWhereNullable((e) => e.name.toLowerCase() == "system");
    return system?.storage
        ?.firstWhereNullable((e) => e.name.toLowerCase() == "account");
  }

  ExtrinsicLookupField buildExtrinsicFields() {
    List<MetadataTypeInfo> payloadTypes = [];
    List<MetadataTypeInfo> extrinsicTypes = [];
    MetadataTypeInfo? address;
    MetadataTypeInfo? signature;
    final extrinsic = metadataInfo.extrinsic.first;
    if (extrinsic.addressType != null) {
      MetadataTypeInfo loockup = api.metadata
          .getLookup(extrinsic.addressType!)
          .typeInfo(api.registry, extrinsic.addressType!);
      address = loockup.copyWith(name: "Address");
    }
    if (extrinsic.signatureType != null) {
      MetadataTypeInfo loockup = api.metadata
          .getLookup(extrinsic.signatureType!)
          .typeInfo(api.registry, extrinsic.signatureType!);
      signature = loockup.copyWith(name: "Signature");
    }
    MetadataTypeInfo call;
    if (extrinsic.callType == null) {
      final pallets = api.metadata.pallets.values.where((e) => e.calls != null);
      final variants = pallets.map((e) => Si1Variant(
          name: e.name,
          fields: [
            Si1Field(name: null, type: e.calls!.type, typeName: null, docs: [])
          ],
          index: e.index,
          docs: e.docs ?? []));
      call = MetadataTypeInfoVariant(
          variants: variants.toList(), typeId: -1, name: "Call");
    } else {
      MetadataTypeInfo loockup = api.metadata
          .getLookup(extrinsic.callType!)
          .typeInfo(api.registry, extrinsic.callType!);
      call = loockup.copyWith(name: "Call");
    }

    for (final i in extrinsic.payloadExtrinsic) {
      MetadataTypeInfo loockup =
          api.metadata.getLookup(i.id).typeInfo(api.registry, i.id);
      loockup = loockup.copyWith(name: i.name, typeId: i.id);
      payloadTypes.add(loockup);
    }
    for (final i in extrinsic.extrinsic) {
      MetadataTypeInfo loockup =
          api.metadata.getLookup(i.id).typeInfo(api.registry, i.id);
      loockup = loockup.copyWith(name: i.name);
      extrinsicTypes.add(loockup);
    }

    return ExtrinsicLookupField(
        call: call,
        extrinsicValidators: extrinsicTypes,
        extrinsicPayloadValidators: payloadTypes,
        extrinsicInfo: extrinsic,
        address: address,
        signature: signature);
  }

  void close() {
    client.service.close();
  }

  void switchVersion(int version) {
    runtimeMetadata.switchMetadata(version);
    _chain = _chain.copyWith(metadataVersion: runtimeMetadata.version);
  }
}

// abstract class SubstrateExtersincPayload {

// }
