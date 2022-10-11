extension StringExtension on String {
  bool get isNonValueZero {
    return isNotEmpty && this != "0";
  }

  bool get isValueZero {
    return isEmpty || this == "0";
  }

  String get reverseFromMoney {
    return replaceAll(',', '');
  }
}
