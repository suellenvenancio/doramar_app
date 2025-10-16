import 'package:flutter/services.dart';

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(text: newValue.text.toLowerCase());
  }
}

class Capitalize extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String originalText = newValue.text;

    final String capitalizedText = _capitalize(originalText);

    final newSelection = TextSelection.collapsed(
      offset: capitalizedText.length,
    );

    return TextEditingValue(text: capitalizedText, selection: newSelection);
  }

  String _capitalize(String text) {
    if (text.isEmpty) {
      return text;
    }

    return text
        .split(RegExp(r'\s+'))
        .map((word) {
          if (word.isNotEmpty) {
            return word[0].toUpperCase() + word.substring(1).toLowerCase();
          }
          return '';
        })
        .join(' ');
  }
}
