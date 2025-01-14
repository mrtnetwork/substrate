import 'package:blockchain_utils/helper/helper.dart';
import 'package:blockchain_utils/utils/utils.dart';
import 'package:substrate/app/error/exception/wallet_ex.dart';
import 'package:substrate/app/types/global.dart';
import 'package:substrate/future/state_manager/state_managment.dart';
import 'package:polkadot_dart/polkadot_dart.dart';

abstract class MetadataFormValidator<METADATA extends MetadataTypeInfo> {
  final METADATA info;
  DynamicVoid? _onRemove;
  DynamicVoid? get onRemove => _onRemove;
  MetadataFormValidator({required this.info});
  bool get isValid;
  factory MetadataFormValidator.fromType(METADATA info) {
    final MetadataFormValidator validator;
    switch (info.typeName) {
      case MetadataTypes.boolean:
        validator = MetadataFormValidatorBoolean(info: info.cast());
        break;
      case MetadataTypes.string:
        validator = MetadataFormValidatorString(info: info.cast());
        break;
      case MetadataTypes.bigInt:
        validator = MetadataFormValidatorBigInt(info: info.cast());
        break;
      case MetadataTypes.int:
        validator = MetadataFormValidatorInt(info: info.cast());
        break;
      case MetadataTypes.none:
        validator = MetadataFormValidatorNone(info: info.cast());
        break;
      case MetadataTypes.array:
      case MetadataTypes.sequence:
        final type = info.cast<MetadataTypeInfoSequence>();
        final parents = type.type.copyWith(name: type.type.name ?? type.name);
        if (type.type.typeName == MetadataTypes.int &&
            type.type.cast<MetadataTypeInfoPromitive>().primitiveType ==
                PrimitiveTypes.u8) {
          validator = MetadataFormValidatorBytes(
              info: type.cast(), type: parents.cast());
        } else {
          validator = MetadataFormValidatorSequence(info: type, type: parents);
        }

        break;
      case MetadataTypes.composit:
        final type = info.cast<MetadataTypeInfoComposit>();
        validator = MetadataFormValidatorComposit(
          info: type,
          types: type.types,
          validators:
              type.types.map((e) => MetadataFormValidator.fromType(e)).toList(),
        );
        break;
      case MetadataTypes.compact:
        final type = info.cast<MetadataTypeInfoCompact>();
        validator = MetadataFormValidator.fromType(
            type.type.copyWith(name: type.type.name ?? type.name));
        break;
      case MetadataTypes.tuple:
        final type = info.cast<MetadataTypeInfoTuple>();
        validator = MetadataFormValidatorTuple(
          info: type,
          types: type.types,
          validators:
              type.types.map((e) => MetadataFormValidator.fromType(e)).toList(),
        );
        break;
      case MetadataTypes.variant:
        final type = info.cast<MetadataTypeInfoVariant>();
        validator = MetadataFormValidatorVariant(info: type);
        break;
    }
    if (validator is! MetadataFormValidator<METADATA>) {
      throw WalletExceptionConst.castingFailed;
    }
    return validator;
  }
  String? get error;
  T cast<T>() {
    if (this is! T) {
      throw WalletExceptionConst.castingFailed;
    }
    return this as T;
  }

  Object? getResult();

  void clear();
  void dispose();

  Object? toJson();

  E? findField<E extends MetadataFormValidator<MetadataTypeInfo>>(String name) {
    if (info.name == name && this is E) {
      return cast<E>();
    }
    return null;
  }
}

abstract class MetadataFormValidatorPromitive<T extends MetadataTypeInfo>
    extends MetadataFormValidator<T> {
  MetadataFormValidatorPromitive({required super.info});
}

class MetadataFormValidatorBoolean
    extends MetadataFormValidatorPromitive<MetadataTypeInfoBoolean> {
  MetadataFormValidatorBoolean({required super.info});

  final Live<bool?> value = Live<bool>(false);
  void setValue(bool? value) {
    if (value == null) return;
    this.value.value = value;
    this.value.notify();
  }

  @override
  String? get error {
    return null;
  }

  @override
  bool get isValid => value.value != null;

  @override
  Object? getResult() {
    return value.value;
  }

  @override
  void clear() {
    value.value = null;
  }

  @override
  void dispose() {
    value.dispose();
  }

  @override
  Object? toJson() {
    return getResult();
  }
}

class MetadataFormValidatorString
    extends MetadataFormValidatorPromitive<MetadataTypeInfoString> {
  MetadataFormValidatorString({required super.info});
  final Live<String?> value = Live<String?>(null);

  void setValue(String? v) {
    value.value = v;
  }

  @override
  bool get isValid => value.value != null;

  @override
  Object? getResult() {
    return value.value;
  }

  @override
  String? get error {
    if (value.value == null) return "some_input_not_filled".tr;
    return null;
  }

  @override
  void clear() {
    value.value = null;
  }

  @override
  void dispose() {
    value.dispose();
  }

  @override
  Object? toJson() {
    return getResult();
  }
}

abstract class MetadataFormValidatorNumeric<T extends MetadataTypeInfoNumeric>
    extends MetadataFormValidatorPromitive<T> {
  MetadataFormValidatorNumeric({required super.info})
      : min = BigRational(minValues[info.primitiveType]!),
        max = BigRational(values[info.primitiveType]!);
  BigRational min;
  BigRational max;
  int? maxScale;

  BigInt? _getResult() {
    final value = this.value.value;
    if (value == null || maxScale == null) return value?.toBigInt();
    final decimals = BigRational(BigInt.from(10).pow(maxScale!));
    final r = (value * decimals).toBigInt();
    return r;
  }

  static final Map<PrimitiveTypes, BigInt> values = {
    // Unsigned types (all using BigInt)
    PrimitiveTypes.u8: BigInt.parse("255"),
    PrimitiveTypes.u16: BigInt.parse("65535"),
    PrimitiveTypes.u32: BigInt.parse("4294967295"),
    PrimitiveTypes.u64: BigInt.parse("18446744073709551615"),
    PrimitiveTypes.u128:
        BigInt.parse("340282366920938463463374607431768211455"),
    PrimitiveTypes.u256: BigInt.parse(
        "115792089237316195423570985008687907853269984665640564039457584007913129607129000"),

    // Signed types (all using BigInt)
    PrimitiveTypes.i8: BigInt.from(127),
    PrimitiveTypes.i16: BigInt.from(32767),
    PrimitiveTypes.i32: BigInt.from(2147483647),
    PrimitiveTypes.i64: BigInt.parse("9223372036854775807"),
    PrimitiveTypes.i128:
        BigInt.parse("170141183460469231731687303715884105727"),
    PrimitiveTypes.i256: BigInt.parse("57846076282404875318142949672953578751"),
  };
  static final Map<PrimitiveTypes, BigInt> minValues = {
    PrimitiveTypes.u8: BigInt.zero,
    PrimitiveTypes.u16: BigInt.zero,
    PrimitiveTypes.u32: BigInt.zero,
    PrimitiveTypes.u64: BigInt.zero,
    PrimitiveTypes.u128: BigInt.zero,
    PrimitiveTypes.u256: BigInt.zero,
    PrimitiveTypes.i8: BigInt.from(-128),
    PrimitiveTypes.i16: BigInt.from(-32768),
    PrimitiveTypes.i32: BigInt.from(-2147483648),
    PrimitiveTypes.i64: BigInt.parse("-9223372036854775808"),
    PrimitiveTypes.i128:
        BigInt.parse("-170141183460469231731687303715884105728"),
    PrimitiveTypes.i256:
        BigInt.parse("-57846076282404875318142949672953578752"),
  };
  final Live<BigRational?> _value = Live(null);
  Live<BigRational?> get value => _value;

  @override
  bool get isValid => value.value != null;
  void setValue(BigRational value) {
    this._value.value = value;
  }

  void setInt(int value) {
    setValue(BigRational.from(value));
  }

  void setPow(int? pow) {
    if (pow == null) return;
    if (pow == maxScale) {
      maxScale = null;
    } else {
      maxScale = pow;
    }
    if (maxScale == null) {
      min = BigRational(minValues[info.primitiveType]!);
      max = BigRational(values[info.primitiveType]!);
    } else {
      final pow = BigRational.from(10).pow(maxScale!);
      min = BigRational(minValues[info.primitiveType]!) / pow;
      max = BigRational(values[info.primitiveType]!) / pow;
    }
    setValue(min);
    value.notify();
  }

  String? validate(String? v) {
    final p = BigRational.tryParseDecimaal(v ?? '');
    return _validate(p);
  }

  String? _validate(BigRational? p) {
    if (p == null) return 'please_enter_a_valid_number'.tr;
    if (p < min || p > max) {
      return 'invalid_number_validator'
          .tr
          .replaceOne(info.primitiveType.name.toUpperCase());
    }
    return null;
  }

  @override
  String? get error => _validate(value.value);

  @override
  void clear() {
    value.value = null;
  }

  @override
  void dispose() {
    value.dispose();
  }

  @override
  Object? toJson() {
    return getResult();
  }

  @override
  E? findField<E extends MetadataFormValidator<MetadataTypeInfo>>(String name) {
    if (info.name == name && this is E) {
      return cast<E>();
    }
    return null;
  }
}

class MetadataFormValidatorBigInt
    extends MetadataFormValidatorNumeric<MetadataTypeInfoBigInt> {
  MetadataFormValidatorBigInt({required super.info});

  @override
  BigInt? getResult() {
    return super._getResult();
  }
}

typedef ONSETVALUEERROR = void Function(String err);

class MetadataFormValidatorInt
    extends MetadataFormValidatorNumeric<MetadataTypeInfoInt> {
  MetadataFormValidatorInt({required super.info});
  @override
  int? getResult() {
    final r = super._getResult();
    if (r != null && !r.isValidInt) {
      throw SubstrateAppException(info.primitiveType.name.toUpperCase());
    }
    return r?.toInt();
  }
}

class MetadataFormValidatorNone
    extends MetadataFormValidator<MetadataTypeInfoNone> {
  MetadataFormValidatorNone({required super.info});
  @override
  bool get isValid => true;

  @override
  Object? getResult() {
    return null;
  }

  @override
  String? get error => null;

  @override
  void clear() {}

  @override
  void dispose() {}

  @override
  Object? toJson() {
    return getResult();
  }
}

class MetadataFormValidatorTuple<T extends MetadataTypeInfo>
    extends MetadataFormValidator<MetadataTypeInfoTuple> {
  final List<T> types;
  final List<MetadataFormValidator> validators;
  MetadataFormValidatorTuple(
      {required this.types, required super.info, required this.validators});

  @override
  bool get isValid => true;

  @override
  Object? getResult() {
    return validators.map((e) => e.getResult()).toList();
  }

  @override
  String? get error {
    for (final i in validators) {
      final err = i.error;
      if (err != null) return err;
    }
    return null;
  }

  @override
  Object? toJson() {
    return validators
        .map((e) => e.getResult())
        .where((e) => e != null)
        .toList();
  }

  @override
  void clear() {
    for (final i in validators) {
      i.clear();
    }
  }

  @override
  void dispose() {
    for (final i in validators) {
      i.dispose();
    }
  }

  @override
  E? findField<E extends MetadataFormValidator<MetadataTypeInfo>>(String name) {
    for (final i in validators) {
      final field = i.findField<E>(name);
      if (field != null) {
        return field;
      }
    }
    return null;
  }
}

class MetadataFormValidatorComposit<T extends MetadataTypeInfo>
    extends MetadataFormValidator<MetadataTypeInfoComposit> {
  final List<T> types;
  final List<MetadataFormValidator> validators;
  MetadataFormValidatorComposit(
      {required this.types, required super.info, required this.validators});
  @override
  bool get isValid => true;

  @override
  String? get error {
    for (final i in validators) {
      final err = i.error;

      if (err != null) return err;
    }
    return null;
  }

  @override
  Object? getResult() {
    return {
      for (int i = 0; i < types.length; i++)
        types[i].name: validators[i].getResult()
    };
  }

  @override
  void clear() {
    for (final i in validators) {
      i.clear();
    }
  }

  @override
  void dispose() {
    for (final i in validators) {
      i.dispose();
    }
  }

  @override
  Object? toJson() {
    if (types.isEmpty) return null;
    if (types.first.name != null) {
      final Map<String?, dynamic> result = {};
      for (int i = 0; i < types.length; i++) {
        final value = validators[i].getResult();
        if (value == null) continue;
        result[types[i].name] = value;
      }
    }
    return validators
        .map((e) => e.getResult())
        .where((e) => e != null)
        .toList();
  }

  @override
  E? findField<E extends MetadataFormValidator<MetadataTypeInfo>>(String name) {
    for (final i in validators) {
      final field = i.findField<E>(name);
      if (field != null) {
        return field;
      }
    }
    return null;
  }
}

enum ArrayFieldType {
  bytes,
  object;

  static ArrayFieldType findType(MetadataTypeInfo type) {
    switch (type.typeName) {
      case MetadataTypes.bigInt:
      case MetadataTypes.int:
      case MetadataTypes.compact:
        final promitiveType = type.cast<MetadataTypeInfoPromitive>();
        if (promitiveType.primitiveType == PrimitiveTypes.u8) {
          return ArrayFieldType.bytes;
        }
        return ArrayFieldType.object;
      default:
        return ArrayFieldType.object;
    }
  }
}

class MetadataFormValidatorSequence<T extends MetadataTypeInfo>
    extends MetadataFormValidator<MetadataTypeInfoSequence<T>> {
  final T type;
  Live<List<MetadataFormValidator<T>>> _validators;
  final ArrayFieldType parentType;
  bool get immutable => length != null;
  int? get length => info.length;
  List<MetadataFormValidator<T>> get validators => _validators.value;

  @override
  bool get isValid => true;

  void add() {
    final newField = MetadataFormValidator.fromType(type);
    newField._onRemove = () {
      remove(newField);
    };
    _validators.value = [..._validators.value, newField];
    _validators.notify();
  }

  void remove(MetadataFormValidator validator) {
    validator._onRemove = null;
    final validators = _validators.value.clone();
    validators.remove(validator);
    _validators.value = validators;
    _validators.notify();
    // _validators.value.remove(value)
  }

  MetadataFormValidatorSequence._({
    required this.type,
    required super.info,
    required this.parentType,
    required List<MetadataFormValidator<T>> validators,
  }) : _validators = Live(validators.immutable);
  factory MetadataFormValidatorSequence(
      {required T type, required MetadataTypeInfoSequence<T> info}) {
    final parentType = ArrayFieldType.findType(type);
    if (parentType == ArrayFieldType.bytes) {
      return MetadataFormValidatorSequence._(
        type: type,
        info: info,
        validators: [MetadataFormValidator.fromType(type)],
        parentType: parentType,
      );
    }
    if (info.length == null) {
      return MetadataFormValidatorSequence._(
          type: type, info: info, validators: [], parentType: parentType);
    }
    return MetadataFormValidatorSequence._(
      type: type,
      info: info,
      validators: List.generate(
          info.length!, (index) => MetadataFormValidator.fromType(type)),
      parentType: parentType,
    );
  }

  @override
  Object? getResult() {
    return validators.map((e) => e.getResult()).toList();
  }

  @override
  String? get error {
    for (final i in validators) {
      final err = i.error;
      if (err != null) return err;
    }
    return null;
  }

  @override
  void clear() {
    if (immutable) {
      for (final i in _validators.value) {
        i.clear();
      }
    } else {
      _validators.value = [];
    }
  }

  @override
  void dispose() {
    for (final i in validators) {
      i.dispose();
    }
  }

  @override
  Object? toJson() {
    return validators
        .map((e) => e.getResult())
        .where((e) => e != null)
        .toList();
  }

  @override
  E? findField<E extends MetadataFormValidator<MetadataTypeInfo>>(String name) {
    for (final i in validators) {
      final field = i.findField<E>(name);
      if (field != null) {
        return field;
      }
    }
    return null;
  }
}

class MetadataFormValidatorBytes
    extends MetadataFormValidator<MetadataTypeInfoSequence<MetadataTypeInfo>> {
  final MetadataTypeInfoInt type;
  MetadataFormValidator<MetadataTypeInfo> validator;
  final ArrayFieldType parentType;
  bool get immutable => length != null;
  int? get length => info.length;
  MetadataFormValidator<MetadataTypeInfo> get validators => validator;

  final Live<String?> _value = Live(null);
  String? get value => _value.value;

  bool get filled => _value.value != null;
  @override
  bool get isValid => _value.value != null;

  String? validate(String? v) {
    if (v == null) return "invalid_hex_validator".tr;
    if (v.trim().isEmpty && length == null) return null;
    final hex = StringUtils.strip0x(v.trim());
    if (StringUtils.isHexBytes(hex)) {
      if (length == null) return null;
      final inHexLength = length! * 2;
      if (hex.length != inHexLength) {
        return "invalid_hex_length"
            .tr
            .replaceOne(inHexLength.toString())
            .replaceTwo(length.toString());
      }
      return null;
    }
    return "invalid_hex_validator".tr;
  }

  void setValue(String? v) {
    _value.value = v;
  }

  @override
  String? get error {
    final err = validate(_value.value);
    if (err != null) return "invalid_hex_validator".tr;
    return null;
  }

  MetadataFormValidatorBytes._({
    required this.type,
    required super.info,
    required this.parentType,
    required this.validator,
  });
  factory MetadataFormValidatorBytes({
    required MetadataTypeInfoInt type,
    required MetadataTypeInfoSequence info,
  }) {
    final parentType = ArrayFieldType.findType(type);
    return MetadataFormValidatorBytes._(
      type: type,
      info: info,
      parentType: parentType,
      validator: MetadataFormValidator.fromType(type).cast(),
    );
  }

  @override
  Object? getResult() {
    return BytesUtils.tryFromHexString(value);
  }

  @override
  void clear() {
    _value.value = null;
  }

  @override
  void dispose() {
    _value.dispose();
  }

  @override
  Object? toJson() {
    return getResult();
  }
}

class MetadataFormValidatorVariant
    extends MetadataFormValidator<MetadataTypeInfoVariant> {
  MetadataFormValidatorVariant({required super.info});

  Si1Variant? _variant;
  Si1Variant? get variant => _variant;

  final Live<MetadataFormValidator?> _validator = Live(null);
  MetadataFormValidator? get validator => _validator.value;

  bool get hasVariant => _validator.value != null;

  @override
  bool get isValid => _variant != null;

  @override
  String? get error {
    if (_variant == null) {
      return "some_input_not_filled".tr;
    }
    return _validator.value!.error;
  }

  void setVariant(
      {required Si1Variant variant, required MetadataTypeInfo type}) {
    _variant = variant;
    _validator.value =
        MetadataFormValidator.fromType(type.copyWith(name: _variant?.name));
    _validator.notify();
  }

  @override
  Object? getResult() {
    if (_variant == null) return null;
    return {_variant!.name: _validator.value!.getResult()};
  }

  @override
  void clear() {
    _variant = null;
    _validator.value = null;
  }

  @override
  void dispose() {
    _validator.dispose();
  }

  @override
  Object? toJson() {
    return getResult();
  }

  @override
  E? findField<E extends MetadataFormValidator<MetadataTypeInfo>>(String name) {
    if (info.name == name && this is E) {
      return this as E;
    }
    return _validator.value?.findField<E>(name);
  }
}
