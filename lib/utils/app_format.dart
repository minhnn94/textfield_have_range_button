import 'package:intl/intl.dart';

class AppFormat {
  static NumberFormat percentFormatter = NumberFormat('#,###.##');

  static String format(num? value,
      {String? format = '#,###', String? regex = ','}) {
    String result =
        value != null ? NumberFormat(format, 'vi').format(value) : '';
    if (regex != null) {
      result = result.replaceAll('.', regex);
    }
    return result;
  }

  static num getNumber(String value) {
    String numValue = value;
    if (value.contains(',')) {
      numValue = value.replaceAll(',', '');
    }
    if (value.contains('.')) {
      numValue = value.replaceAll('.', '');
    }
    return num.tryParse(numValue) ?? 0;
  }
}
