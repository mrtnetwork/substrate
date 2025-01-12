import 'package:substrate/app/config/cofing.dart';
import 'package:substrate/future/controllers/app.dart';
import 'package:substrate/future/pages/home/home.dart';
import 'package:substrate/future/widgets/widgets/scroll_config.dart';
import 'package:substrate/storage/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'future/constant/constant.dart';
import 'future/state_manager/state_managment.dart';
import 'future/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = await RepositoryStorage.loadConfigStatic();
  ThemeController.changeColor(config.color);
  ThemeController.changeBrightness(config.brightness);
  runApp(StateRepository(child: MySubstrate(config)));
}

class MySubstrate extends StatelessWidget {
  const MySubstrate(this.config, {super.key});
  final APPConfig config;

  @override
  Widget build(BuildContext context) {
    return MrtViewBuilder<APPStateController>(
      controller: () => APPStateController(config),
      removable: false,
      stateId: APPConst.stateMain,
      repositoryId: APPConst.stateMain,
      builder: (m) {
        return MaterialApp(
            scaffoldMessengerKey: StateRepository.messengerKey(context),
            title: APPConst.name,
            scrollBehavior: AppScrollBehavior(),
            home: const SubstrateHome(),
            builder: (context, child) {
              ThemeController.updatePrimary(context.theme);
              return MediaQuery(
                  data: context.mediaQuery.copyWith(
                      textScaler: context.mediaQuery.textScaler
                          .clamp(maxScaleFactor: 1.4)),
                  child: child!);
            },
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate
            ],
            theme: ThemeController.appTheme,
            darkTheme: ThemeController.appTheme,
            locale: ThemeController.locale,
            showSemanticsDebugger: false,
            debugShowCheckedModeBanner: false,
            color: ThemeController.appTheme.colorScheme.primary,
            navigatorKey: StateRepository.navigatorKey(context));
      },
    );
  }
}
