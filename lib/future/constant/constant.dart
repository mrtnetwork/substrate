class APPConst {
  static const String stateMain = 'main';
  static const String storageState = 'Storage';
  static const String callFields = 'call';
  static const String extrinsicState = "Extrinsic";
  static const int defaultMetadataVersion = 15;
  static const String name = "Substrate";
  static const String repositoryPage =
      "https://github.com/mrtnetwork/substrate";
  static String defaultChain = "Polkadot";
  static const Duration animationDuraion = Duration(milliseconds: 400);
  static const Duration milliseconds100 = Duration(milliseconds: 100);
  static const Duration oneSecoundDuration = Duration(seconds: 1);
  static const Duration twoSecoundDuration = Duration(seconds: 2);
  static const Duration tenSecoundDuration = Duration(seconds: 10);

  static const double double80 = 80;
  static const double double40 = 40;
  static const double double20 = 20;
  static const double iconSize = 24;
  static const double largeIconSize = 80;
  static const double tooltipConstrainedWidth = 300;
  static const double dialogWidth = 650;
  static const double maxViewWidth = 650;
  static const double maxDialogHeight = 600;
  static const double maxTextFieldWidth = 400;
  static const double qrCodeWidth = 300;
  static final RegExp accountNameRegExp = RegExp(r'^[^\n]{0,20}$');
  static final RegExp keyNameRegex = RegExp(r'^[^\n]{0,20}$');
  static final RegExp hex32Bytes = RegExp(r'^(0x)?[0-9a-fA-F]{64}$');
  static final RegExp hex32Or64Bytes =
      RegExp(r'^(0x)?[a-fA-F0-9]{64}$|^(0x)?[a-fA-F0-9]{128}$');

  static final hrpRegex = RegExp(r'^[a-z][a-z0-9]*$');
  static const double circleRadius25 = 25;
  static const double circleRadius12 = 12.5;
  static const double elevation = 2;
  static const double desktopAppWidth = 1200;
  static const double desktopAppHeight = 768;
  static const double naviationRailWidth = 80;
  static const int maximumHeaderValue = 400;
  static const double largeCircleRadius = 60;
}
