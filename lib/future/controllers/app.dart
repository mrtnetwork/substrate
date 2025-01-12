import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:blockchain_utils/helper/helper.dart';
import 'package:substrate/app/config/cofing.dart';
import 'package:substrate/app/error/exception.dart';
import 'package:substrate/app/synchronized/basic_lock.dart';
import 'package:substrate/app/tools/func.dart';
import 'package:substrate/future/constant/constant.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:substrate/future/theme/theme.dart';
import 'package:substrate/future/widgets/widgets/progress_bar/progress.dart';
import 'package:substrate/storage/repository.dart';
import 'package:substrate/substrate/api/api.dart';
import 'package:substrate/substrate/constant/default_chains.dart';
import 'package:substrate/substrate/models/chains.dart';
import 'package:flutter/material.dart';

enum HomePageMode { network, init }

class APPStateController extends StateController with RepositoryStorage {
  APPStateController(this._config);
  final pageProgress = GlobalKey<PageProgressState>();
  APPConfig _config;
  HomePageMode _page = HomePageMode.init;
  HomePageMode get page => _page;
  SubstrateApi? _substrate;
  SubstrateApi get substrate => _substrate!;
  NetworkInfo? get currentNetwork => _substrate?.networkInfo;
  RpcEndpoint? get currentEndpoint => _substrate?.endpoint;
  bool get inited => _substrate != null;
  List<NetworkInfo> _importedChains = const [];
  Set<NetworkInfo> _chains = const {};
  Set<NetworkInfo> get chains => _chains;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final defaults = defaultChains.map((e) => NetworkInfo.fromJson(e)).toList();
  final _lock = SynchronizedLock();

  Future<LatestChain> _initChains() async {
    final lastChain = await latestChain();
    final importedChains = await loadChains();
    // print(StringUtils.fromJson(APPConst.defaultNetwork.toJson()));

    _chains = [
      ...importedChains,
      ...defaultChains.map((e) => NetworkInfo.fromJson(e)),
    ].toImutableSet;
    NetworkInfo currentChain =
        _chains.firstWhere((e) => e.name == APPConst.defaultChain);
    RpcEndpoint currentRpc = currentChain.rpcEndpoints.first;
    int version = APPConst.defaultMetadataVersion;
    if (lastChain != null) {
      final chain = _chains.firstWhereNullable((e) => e == lastChain.network);
      if (chain != null && chain.rpcEndpoints.contains(lastChain.endpoint)) {
        currentChain = chain;
        currentRpc =
            chain.rpcEndpoints.firstWhere((e) => e == lastChain.endpoint);
        version = lastChain.metadataVersion;
      }
    }
    return LatestChain(
        network: currentChain, endpoint: currentRpc, metadataVersion: version);
  }

  Future<void> _init() async {
    pageProgress.progressText('retrieving_metadata_please_wait'.tr);
    final chain = await _initChains();
    notify();
    final sub = await MethodUtils.call(() async {
      return await SubstrateApi.init(chain);
    });
    if (sub.hasError) {
      pageProgress.errorText(sub.error!.tr,
          backToIdle: false,
          button: ProgressButtonWidget(
              label: 'switch_network'.tr,
              onTap: () {
                scaffoldKey.currentState?.openDrawer();
              }));
    } else {
      _substrate?.close();
      _substrate = sub.result;
      _page = HomePageMode.network;
      notify();
      pageProgress.success();
    }
  }

  final Cancelable _cancelable = Cancelable();

  Future<void> switchChain(
      {required NetworkInfo network, required RpcEndpoint endpoint}) async {
    scaffoldKey.currentState?.closeDrawer();
    _cancelable.dispose();
    await _lock.synchronized(() async {
      LatestChain chain = LatestChain(network: network, endpoint: endpoint);
      if (chain.network == _substrate?.networkInfo) {
        chain =
            chain.copyWith(metadataVersion: _substrate!.chain.metadataVersion);
      }
      pageProgress.progressText("switching_network_please_wait".tr);
      _page = HomePageMode.init;
      notify();
      final sub = await MethodUtils.call(() async {
        return await SubstrateApi.init(chain);
      }, cancelable: _cancelable);
      if (sub.hasError) {
        if (sub.isCancel) return;
        pageProgress.errorText(sub.error!.tr,
            backToIdle: false,
            button: ProgressButtonWidget(
                label: 'switch_network'.tr,
                onTap: () {
                  scaffoldKey.currentState?.openDrawer();
                }));
      } else {
        _substrate?.close();
        _substrate = sub.result;

        _page = HomePageMode.network;
        await saveLatestChain(sub.result.chain);
        notify();
        pageProgress.success();
      }
    });
  }

  Future<void> switchVersion(int metadataVersion) async {
    _cancelable.dispose();
    await _lock.synchronized(() async {
      if (!inited) return;
      pageProgress.progressText("switching_metadata_please_wait".tr);
      final r = await MethodUtils.call(() async {
        _substrate!.switchVersion(metadataVersion);
      }, cancelable: _cancelable, delay: APPConst.oneSecoundDuration);
      if (r.hasResult) {
        await saveLatestChain(substrate.chain);
      }
      notify();
      pageProgress.backToIdle();
    });
  }

  Future<void> addNewChain(
      {required RpcEndpoint endpoint, required String networkName}) async {
    await _lock.synchronized(() async {
      if (networkName.isEmpty) {
        throw const SubstrateAppException("network_name_validator");
      }
      NetworkInfo chain = chains.firstWhere((e) => e.name == networkName,
          orElse: () => NetworkInfo(name: networkName));
      chain = chain.copyWith(
          rpcEndpoints: [...chain.rpcEndpoints, endpoint].toImutableSet);

      final sub = await MethodUtils.call(() async {
        return await SubstrateApi.init(
            LatestChain(network: chain, endpoint: endpoint));
      });
      sub.result.close();

      final updateChains = [..._importedChains, chain];
      _importedChains = updateChains;
      _chains = [chain, ..._chains].toImutableSet;
      await saveChains(updateChains);
      notify();
    });
  }

  Future<void> toggleBrightness() async {
    scaffoldKey.currentState?.closeDrawer();
    await _lock.synchronized(() async {
      ThemeController.toggleBrightness();
      _config = _config.copyWith(brightness: ThemeController.appBrightness);
      await saveConfig(_config);
    });
    notify(APPConst.stateMain);
  }

  Future<void> changeColor(Color? color) async {
    if (color == null) return;
    scaffoldKey.currentState?.closeDrawer();
    await _lock.synchronized(() async {
      ThemeController.changeColor(color);
      _config = _config.copyWith(color: ThemeController.appColor);
      await saveConfig(_config);
    });
    notify(APPConst.stateMain);
  }

  @override
  void ready() {
    super.ready();
    _init();
  }
}
