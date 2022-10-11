import 'package:intl/intl.dart';

extension NumExtension on num {
  String toFormatThousandSeparator() {
    final NumberFormat format = NumberFormat("#,###.##");
    String result = format.format(this);
    return result.trim();
  }

  num get avoidFloatingPoint {
    return num.parse(toStringAsFixed(1));
  }
}
