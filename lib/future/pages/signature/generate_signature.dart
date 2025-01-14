import 'package:blockchain_utils/blockchain_utils.dart';
import 'package:substrate/app/tools/func.dart';
import 'package:substrate/future/constant/constant.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:substrate/future/widgets/widgets.dart';
import 'package:substrate/substrate/models/extrinsic.dart';
import 'package:flutter/material.dart';
import 'package:polkadot_dart/polkadot_dart.dart';
import 'package:substrate/substrate/models/signature.dart';

// enum _SiningAlgorithm {
//   ed25519(SubstrateKeyAlgorithm.ed25519),
//   secp256k1(SubstrateKeyAlgorithm.secp256k1),
//   sr25519(SubstrateKeyAlgorithm.sr25519),
//   ethereum(null);

//   const _SiningAlgorithm(this.algorithm);

//   final SubstrateKeyAlgorithm? algorithm;
// }

enum _SigningMode { sign, insert }

class GenerateSignatureView extends StatefulWidget {
  const GenerateSignatureView(
      {required this.payload, this.scrollController, super.key});
  final ExtrinsicPayloadInfo payload;
  final ScrollController? scrollController;

  @override
  State<GenerateSignatureView> createState() => _GenerateSignatureViewState();
}

class _GenerateSignatureViewState extends State<GenerateSignatureView>
    with SafeState<GenerateSignatureView> {
  final GlobalKey<PageProgressState> progressKey = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey();
  SignatureType signingAlogrithm = SignatureType.ed25519;
  _SigningMode signingMode = _SigningMode.sign;
  void toggleSigningMode(bool? _) {
    if (signingMode == _SigningMode.sign) {
      signingMode = _SigningMode.insert;
    } else {
      signingMode = _SigningMode.sign;
    }
    updateState();
  }

  String privateKey = '';
  String? signature;
  void onChangePrivateKey(String v) {
    privateKey = v;
  }

  String? onValidatePrivateKey(String? v) {
    if (APPConst.hex32Or64Bytes.hasMatch(v ?? '')) return null;
    return "invalid_private_key_validator".tr.replaceOne(signingAlogrithm.name);
  }

  void onChangeSignature(String v) {
    signature = v;
  }

  String? onValidateSignature(String? v) {
    if (v != null && v.trim().isNotEmpty && StringUtils.isHexBytes(v)) {
      return null;
    }
    return "enter_hex_bytes".tr.replaceOne(signingAlogrithm.name);
  }

  Map<SignatureType, Text> signingAlgorithmItem = {};

  void onChangeAlgorithm(SignatureType? algorithm) {
    signingAlogrithm = algorithm ?? signingAlogrithm;
    updateState();
  }

  List<int> sign() {
    final keyBytes = BytesUtils.fromHexString(privateKey);
    final payload = BytesUtils.fromHexString(widget.payload.payload);
    switch (signingAlogrithm.algorithm) {
      case null:
        return MoonbeamPrivateKey.fromBytes(keyBytes).sign(payload).toBytes();
      default:
        return SubstratePrivateKey.fromPrivateKey(
                keyBytes: keyBytes, algorithm: signingAlogrithm.algorithm!)
            .sign(payload);
    }
  }

  Future<void> signPayload() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    progressKey.progressText("signing_payload_please_wait".tr);
    final result = await MethodUtils.call(() async => sign(),
        delay: APPConst.oneSecoundDuration);
    if (result.hasError) {
      progressKey.errorText(result.error!.tr,
          showBackButton: true, backToIdle: false);
    } else {
      signature = BytesUtils.toHexString(result.result);
      progressKey.backToIdle();
    }
  }

  Future<void> init() async {
    signingAlgorithmItem = {
      for (final i in SignatureType.values) i: Text(i.name.camelCase)
    };
    progressKey.backToIdle();
  }

  void setupSignature() {
    if (signature == null ||
        (signature?.isEmpty ?? true) ||
        !StringUtils.isHexBytes(signature ?? '')) {
      return;
    }
    context.pop(widget.payload.setSignature(
        SubstrateSignature(type: signingAlogrithm, signature: signature!)));
  }

  @override
  void onInitOnce() {
    super.onInitOnce();
    MethodUtils.after(() async => init(), duration: APPConst.animationDuraion);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPageView(
        appBar: AppBar(title: Text("sign_payload".tr)),
        child: Form(
          key: formKey,
          child: PageProgress(
            backToIdle: APPConst.oneSecoundDuration,
            initialStatus: StreamWidgetStatus.progress,
            key: progressKey,
            child: (context) => Center(
              child: CustomScrollView(
                  shrinkWrap: true,
                  controller: widget.scrollController,
                  slivers: [
                    SliverConstraintsBoxView(
                        padding: WidgetConstant.paddingHorizontal10,
                        sliver: SliverMainAxisGroup(
                          slivers: [
                            SliverToBoxAdapter(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("payload".tr,
                                      style: context.textTheme.titleMedium),
                                  WidgetConstant.height8,
                                  ContainerWithBorder(
                                    child: CopyableTextWidget(
                                        text: widget.payload.payload,
                                        color: context.onPrimaryContainer,
                                        maxLines: 3),
                                  ),
                                  WidgetConstant.height20,
                                  AppCheckListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text("payload_already_signed".tr),
                                    onChanged: toggleSigningMode,
                                    value: signingMode == _SigningMode.insert,
                                  ),
                                  WidgetConstant.height20,
                                ],
                              ),
                            ),
                            APPSliverAnimatedSwitcher(
                                enable: signature == null,
                                widgets: {
                                  true: (context) =>
                                      APPSliverAnimatedSwitcher<_SigningMode>(
                                          enable: signingMode,
                                          widgets: {
                                            _SigningMode.sign: (context) {
                                              return SliverMainAxisGroup(
                                                  slivers: [
                                                    SliverToBoxAdapter(
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                                "signing_algorithm"
                                                                    .tr,
                                                                style: context
                                                                    .textTheme
                                                                    .titleMedium),
                                                            WidgetConstant
                                                                .height8,
                                                            AppDropDownBottom(
                                                                hint:
                                                                    "signing_algorithm"
                                                                        .tr,
                                                                items:
                                                                    signingAlgorithmItem,
                                                                onChanged:
                                                                    onChangeAlgorithm,
                                                                value:
                                                                    signingAlogrithm),
                                                            WidgetConstant
                                                                .height20,
                                                            Text(
                                                                "private_key"
                                                                    .tr,
                                                                style: context
                                                                    .textTheme
                                                                    .titleMedium),
                                                            WidgetConstant
                                                                .height8,
                                                            AppTextField(
                                                                label:
                                                                    'private_key'
                                                                        .tr,
                                                                onChanged:
                                                                    onChangePrivateKey,
                                                                validator:
                                                                    onValidatePrivateKey,
                                                                obscureText:
                                                                    true,
                                                                pasteIcon:
                                                                    true),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                FixedElevatedButton(
                                                                    padding:
                                                                        WidgetConstant
                                                                            .paddingVertical40,
                                                                    onPressed:
                                                                        signPayload,
                                                                    child: Text(
                                                                        "sign_payload"
                                                                            .tr)),
                                                              ],
                                                            )
                                                          ]),
                                                    ),
                                                  ]);
                                            },
                                            _SigningMode.insert: (context) {
                                              return SliverMainAxisGroup(
                                                  slivers: [
                                                    SliverToBoxAdapter(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text("signature".tr,
                                                              style: context
                                                                  .textTheme
                                                                  .titleMedium),
                                                          Text(
                                                              "enter_signature_desc"
                                                                  .tr),
                                                          WidgetConstant
                                                              .height8,
                                                          AppTextField(
                                                              label: 'signature'
                                                                  .tr,
                                                              onChanged:
                                                                  onChangeSignature,
                                                              validator:
                                                                  onValidateSignature,
                                                              minlines: 3,
                                                              maxLines: 5,
                                                              pasteIcon: true),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              FixedElevatedButton(
                                                                  padding:
                                                                      WidgetConstant
                                                                          .paddingVertical40,
                                                                  onPressed:
                                                                      setupSignature,
                                                                  child: Text(
                                                                      "sign_payload"
                                                                          .tr)),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ]);
                                            }
                                          }),
                                  false: (context) => SliverToBoxAdapter(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("signature".tr,
                                                  style: context
                                                      .textTheme.titleMedium),
                                              WidgetConstant.height8,
                                              ContainerWithBorder(
                                                child: CopyableTextWidget(
                                                    text: signature!,
                                                    maxLines: 3,
                                                    color: context
                                                        .onPrimaryContainer),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  FixedElevatedButton(
                                                      padding: WidgetConstant
                                                          .paddingVertical40,
                                                      onPressed: setupSignature,
                                                      child: Text(
                                                          "setup_signature"
                                                              .tr)),
                                                ],
                                              )
                                            ]),
                                      ),
                                }),
                          ],
                        ))
                  ]),
            ),
          ),
        ));
  }
}
