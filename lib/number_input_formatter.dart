import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';


abstract class NumberInputFormatter extends TextInputFormatter {
  /// check character from user input, not inserted by formatter
  bool _isUserInput(String s);
  /// format user input with formatter
  String _formatPattern(String digits);
  /// remove all invalid characters
  TextEditingValue _formatValue(TextEditingValue oldValue, TextEditingValue newValue);

  /// previous value, stored for two and more step formatting (when added separators)
  TextEditingValue _previousNewValue;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    /// if new value contains changes made formatter only
    if (newValue == _previousNewValue) {
      return oldValue;
    }
    _previousNewValue = newValue;

    var value = _formatValue(oldValue, newValue);
    var selectionIndex = value.selection.end;

    /// format original string (adding some separators)
    final result = _formatPattern(value.text);

    /// calculate count of inserted characters and count of user input characters
    var insertedSeparatorsCount = 0;
    var insertedByUserCount = 0;
    for (int i = 0; i < result.length && insertedByUserCount < selectionIndex; i++) {
      final character = result[i];
      if (_isUserInput(character)) {
        insertedByUserCount++;
      } else {
        insertedSeparatorsCount++;
      }
    }

    /// adjust selection according to number of inserted characters staying before selection
    selectionIndex = min(selectionIndex + insertedSeparatorsCount, result.length);

    /// if selection is right after an inserted separator, it should be moved backward,
    /// user cannot delete separators when cursor stands right after
    if (selectionIndex - 1 >= 0 && selectionIndex - 1 < result.length &&
        !_isUserInput(result[selectionIndex - 1])) {
      selectionIndex--;
    }

    return value.copyWith(
        text: result,
        selection: TextSelection.collapsed(offset: selectionIndex),
        composing: defaultTargetPlatform == TargetPlatform.iOS ? TextRange(start: 0, end: 0) : TextRange.empty);
  }
}