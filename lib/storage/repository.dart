import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:substrate/app/config/cofing.dart';
import 'package:substrate/substrate/models/chains.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class _RepositoryStorageConst {
  static const String chainsKey = 'chains_';
  static const String config = 'config_';
  static const String latestChain = 'lastestChain';
}

mixin RepositoryStorage {
  static const _storage = FlutterSecureStorage();
  static Future<APPConfig> loadConfigStatic() async {
    try {
      final r = await _storage.read(key: _RepositoryStorageConst.config);
      final json = StringUtils.tryToJson(r);
      return APPConfig.fromJson(json);
    } catch (_) {
      return APPConfig.defaultConfig;
    }
  }

  Future<void> writeStorage(
      {required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> readStorage(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> removeStorage(String key) async {
    await _storage.delete(key: key);
  }

  Future<List<NetworkInfo>> loadChains() async {
    try {
      final r = await readStorage(_RepositoryStorageConst.chainsKey);
      if (r == null) return [];
      final json = StringUtils.toJson(r);
      return (json as List).map((e) => NetworkInfo.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<APPConfig> loadConfig() async {
    try {
      final r = await readStorage(_RepositoryStorageConst.config);
      final json = StringUtils.tryToJson(r);
      return APPConfig.fromJson(json);
    } catch (_) {
      return APPConfig.defaultConfig;
    }
  }

  Future<void> saveConfig(APPConfig config) async {
    await writeStorage(
        key: _RepositoryStorageConst.config,
        value: StringUtils.fromJson(config.toJson()));
  }

  Future<void> saveChains(List<NetworkInfo> chains) async {
    await writeStorage(
        key: _RepositoryStorageConst.chainsKey,
        value: StringUtils.fromJson(chains.map((e) => e.toJson()).toList()));
  }

  Future<LatestChain?> latestChain() async {
    final r = await readStorage(_RepositoryStorageConst.latestChain);
    try {
      return LatestChain.fromJson(StringUtils.toJson(r));
    } catch (_) {
      return null;
    }
  }

  Future<void> saveLatestChain(LatestChain latestChain) async {
    await writeStorage(
        key: _RepositoryStorageConst.latestChain,
        value: StringUtils.fromJson(latestChain.toJson()));
  }
}
