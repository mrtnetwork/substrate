import 'package:polkadot_dart/polkadot_dart.dart';

class BlockHashWithEra {
  final String hash;
  final MortalEra era;
  const BlockHashWithEra({required this.hash, required this.era});

  String get eraIndex => "Mortal${era.index}";
  int get eraValue => era.era;
}
