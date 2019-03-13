import 'dart:math';

import 'package:flutter/services.dart';
import 'package:vader_mask/number_input_formatter.dart';

///
/// Converts a numeric input to credit card number (4-digit grouping).
/// For example, a input of `12345678` should be formatted to `1234 5678`.
///
class CreditCardFormatter extends NumberInputFormatter {
  final String separator;

  static final RegExp _digitOnlyRegex = RegExp(r'\d+');
  static final WhitelistingTextInputFormatter _digitOnlyFormatter = WhitelistingTextInputFormatter(_digitOnlyRegex);

  CreditCardFormatter({this.separator = ' '});

  @override
  String formatPattern(String digits) {
    final length = digits.length;
    var groupEndIndex = min(4, length);
    var groupStartIndex = 0;
    var result = new StringBuffer();
    for (; groupEndIndex <= length; groupEndIndex += min(4, max(1, length - groupEndIndex))) {
      result.write(digits.substring(groupStartIndex, groupEndIndex));
      if (groupEndIndex < length) {
        result.write(separator);
      }
      groupStartIndex = groupEndIndex;
    }
    return result.toString();
  }

  @override
  TextEditingValue formatValue(TextEditingValue oldValue, TextEditingValue newValue) {
    return _digitOnlyFormatter.formatEditUpdate(oldValue, newValue);
  }

  @override
  bool isUserInput(String s) {
    return _digitOnlyRegex.firstMatch(s) != null;
  }
}