import 'package:polkadot_dart/polkadot_dart.dart';

enum SignatureType {
  ed25519(identifier: "Ed25519", algorithm: SubstrateKeyAlgorithm.ed25519),
  sr25519(identifier: "Sr25519", algorithm: SubstrateKeyAlgorithm.sr25519),
  ecdsa(identifier: "Ecdsa", algorithm: SubstrateKeyAlgorithm.ecdsa),
  ethereum(identifier: "Ethereum");

  final String identifier;
  final SubstrateKeyAlgorithm? algorithm;
  const SignatureType({required this.identifier, this.algorithm});
}

class SubstrateSignature {
  final SignatureType type;
  final String signature;
  const SubstrateSignature({required this.type, required this.signature});
}
