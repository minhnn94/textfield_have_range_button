import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:textfield_have_range_button/extensions/num.dart';
import 'package:textfield_have_range_button/extensions/string_extension.dart';
import 'package:textfield_have_range_button/utils/app_format.dart';
import 'package:textfield_have_range_button/widgets/base/text_field_base.dart';
import 'package:textfield_pattern_formatter/formatters/thousand_separator_decimal_formatter.dart';

enum StockTextFieldType { price, volume }

const decimalDigit = 2;
const inputHeight = 50.0;

class UpAndDownTextField extends StatefulWidget {
  const UpAndDownTextField({
    Key? key,
    this.minValue,
    this.maxValue,
    this.title,
    this.type = TextFieldType.price,
    this.controller,
    this.padding,
    this.onChanged,
    this.step = 1,
    this.disable = false,
    this.errorText = '',
    this.inputFormatters,
    this.isShowErrorText = true,
    this.titleStyle,
    this.contentStyle,
    this.baseValue,
    this.decoration,
    this.rightButton,
    this.leftButton,
  }) : super(key: key);

  final String? title;
  final TextEditingController? controller;
  final TextFieldType? type;
  final EdgeInsetsGeometry? padding;
  final Function(num)? onChanged;
  final num? minValue;
  final num? maxValue;
  final num step;
  final bool disable;
  final String errorText;
  final List<TextInputFormatter>? inputFormatters;
  final bool isShowErrorText;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final String? baseValue;
  final InputDecoration? decoration;
  final Widget? rightButton;
  final Widget? leftButton;

  @override
  State<UpAndDownTextField> createState() => _UpAndDownTextFieldState();
}

class _UpAndDownTextFieldState extends State<UpAndDownTextField> {
  bool get hasErrorText => widget.errorText.isNotEmpty;
  final FocusNode myFocusNode = FocusNode();
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller =
        widget.controller ?? TextEditingController(text: widget.baseValue);
    myFocusNode.addListener(() {
      if (!myFocusNode.hasFocus) {
        _handleUnFocus();
      }
    });
  }

  void _handleUnFocus() {
    String text = controller.text;
    if (text.endsWith('.')) {
      text = text.substring(0, text.length - 1);
      controller.text = text;
    }
  }

  String getValueCurrently() {
    String text = (controller.text);
    if (text.isEmpty) {
      if (widget.baseValue != null) {
        text = widget.baseValue!;
      } else {
        text = "0";
      }
    }
    return text.reverseFromMoney;
  }

  void onPressPlus() {
    if (widget.disable) return;
    String text = getValueCurrently();
    try {
      num value = num.parse(text);

      final surPlus = getSurPlus(value);
      value += widget.step - surPlus;
      updateAfterActions(value);
    } catch (e) {
      throw Exception('Value is not a number: $e');
    }
  }

  void onPressMinus() {
    if (widget.disable) return;
    String text = getValueCurrently();
    try {
      num value = num.parse(text);

      if (getSurPlus(value) == 0) {
        value -= widget.step;
      } else {
        value -= getSurPlus(value);
      }
      if (value < 0) {
        value = 0;
      }
      updateAfterActions(value);
    } catch (e) {
      throw Exception('Value is not a number: $e');
    }
  }

  void updateAfterActions(num value) {
    final content = value.toFormatThousandSeparator();
    controller
      ..text = content
      ..selection = TextSelection.collapsed(offset: content.length);

    if (widget.onChanged != null) {
      widget.onChanged!(num.parse(content.reverseFromMoney));
    }
  }

  void onChangedText(String value) {
    final isPrice = widget.type == StockTextFieldType.price;
    if (!isPrice) {
      controller.value = TextEditingValue(
        text: formNum(value),
        selection: TextSelection.collapsed(
          offset: formNum(value).length,
        ),
      );
    }
    if (widget.onChanged != null) {
      widget.onChanged!(num.tryParse(value.reverseFromMoney) ?? 0);
    }
  }

  TextStyle getContentStyle() {
    if (widget.contentStyle != null) {
      return widget.contentStyle!;
    } else {
      if (num.tryParse(controller.text) == 0) {
        return const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black38);
      } else {
        return const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black);
      }
    }
  }

  num getSurPlus(num value) {
    const ratio1K = 1000.0;
    final stepPrice = (widget.step * ratio1K).avoidFloatingPoint;
    final total = (value * ratio1K).avoidFloatingPoint;
    final difference =
        ((total - getBaseValueInteger() * ratio1K)).avoidFloatingPoint;
    final surPlus = difference % stepPrice;
    return surPlus / ratio1K;
  }

  int getBaseValueInteger() {
    return (num.tryParse(widget.baseValue ?? "0") ?? 0).toInt();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldBase(
      controller: controller,
      onChanged: onChangedText,
      onLeftAction: onPressMinus,
      onRightAction: onPressPlus,
      inputFormatters: [ThousandSeparatorDecimalFormatter()],
      baseValue: '0',
      minValue: widget.minValue,
      maxValue: widget.maxValue,
      type: widget.type,
      padding: widget.padding,
      step: widget.step,
      disable: widget.disable,
      errorText: widget.errorText,
      isShowErrorText: widget.isShowErrorText,
      titleStyle: widget.titleStyle,
      contentStyle: widget.contentStyle,
      decoration: widget.decoration,
      rightButton: widget.rightButton,
      leftButton: widget.leftButton,
    );
  }

  String formNum(String s) {
    return AppFormat.format(AppFormat.getNumber(s));
  }
}
