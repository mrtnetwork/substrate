import 'package:blockchain_utils/utils/numbers/rational/big_rational.dart';
import 'package:flutter/services.dart';

class BigRangeTextInputFormatter extends TextInputFormatter {
  final BigInt min;
  final BigInt? max;

  BigRangeTextInputFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newString = newValue.text;

    if (newString.isNotEmpty) {
      final BigInt? enteredNumber = BigInt.tryParse(newString);
      if (enteredNumber != null) {
        if (enteredNumber < min) {
          return BigRetionalRangeTextInputFormatter._buildOldValue(oldValue);
        } else if (max != null && enteredNumber > max!) {
          return BigRetionalRangeTextInputFormatter._buildOldValue(oldValue);
        } else {
          newString = enteredNumber.toString();
        }
      } else {
        return BigRetionalRangeTextInputFormatter._buildOldValue(oldValue);
      }
    } else {
      newString = '';
    }
    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}

class RangeTextInputFormatter extends TextInputFormatter {
  final int min;
  final int? max;

  RangeTextInputFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newString = newValue.text;

    if (newString.isNotEmpty) {
      final int? enteredNumber = int.tryParse(newString);
      if (enteredNumber != null) {
        if (enteredNumber < min) {
          return BigRetionalRangeTextInputFormatter._buildOldValue(oldValue);
        } else if (max != null && enteredNumber > max!) {
          return BigRetionalRangeTextInputFormatter._buildOldValue(oldValue);
        } else {
          newString = enteredNumber.toString();
        }
      } else {
        return BigRetionalRangeTextInputFormatter._buildOldValue(oldValue);
      }
    } else {
      newString = min.toString();
    }
    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}

class BigRetionalRangeTextInputFormatter extends TextInputFormatter {
  final BigRational? min;
  final BigRational? max;
  final int? maxScale;
  final bool allowDecimal;
  final bool allowSign;

  BigRetionalRangeTextInputFormatter(
      {required this.min,
      this.max,
      this.maxScale,
      this.allowSign = true,
      this.allowDecimal = true});

  static TextEditingValue _buildOldValue(TextEditingValue oldValue) {
    final BigRational? enteredNumber =
        BigRational.tryParseDecimaal(oldValue.text);
    if (enteredNumber == null) {
      return const TextEditingValue(
        text: "",
        selection: TextSelection.collapsed(offset: 0),
      );
    }
    return oldValue;
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final String newString = newValue.text;
    if (newString.isNotEmpty) {
      final BigRational? enteredNumber =
          BigRational.tryParseDecimaal(newString);
      if (enteredNumber != null) {
        if (min != null && enteredNumber < min!) {
          return _buildOldValue(oldValue);
        } else if (max != null && enteredNumber > max!) {
          return _buildOldValue(oldValue);
        } else if (maxScale != null && enteredNumber.scale > maxScale!) {
          return _buildOldValue(oldValue);
        } else if (!allowDecimal &&
            (enteredNumber.isDecimal || newString.contains("."))) {
          return _buildOldValue(oldValue);
        } else if (!allowSign && enteredNumber.isNegative) {
          return _buildOldValue(oldValue);
        }
      } else {
        return _buildOldValue(oldValue);
      }
    }
    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}
