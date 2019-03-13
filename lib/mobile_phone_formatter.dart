import 'package:flutter/services.dart';
import 'package:vader_mask/number_input_formatter.dart';

class MobilePhoneFormatter extends NumberInputFormatter {
  static final RegExp _digitOnlyRegex = RegExp(r'\d+');
  static final _digitFormatter = new WhitelistingTextInputFormatter(_digitOnlyRegex);

  @override
  String _formatPattern(String digits) {
    StringBuffer result = StringBuffer();

    for (var i = 0; i < digits.length; i++) {
      if (i == 0) {
        result.write('(');
      }
      else if (i == 3) {
        result.write(') ');
      }
      else if (i == 6) {
        result.write('-');
      }
      else if (i == 8) {
        result.write('-');
      }

      result.write(digits[i]);
    }
    return result.toString();
  }

  @override
  TextEditingValue _formatValue(TextEditingValue oldValue, TextEditingValue newValue) {
    return _digitFormatter.formatEditUpdate(oldValue, newValue);
  }

  @override
  bool _isUserInput(String s) {
    return _digitOnlyRegex.firstMatch(s) != null;
  }
}