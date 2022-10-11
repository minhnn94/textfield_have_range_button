import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_my_library/extensions/num.dart';
import 'package:test_my_library/extensions/string_extension.dart';
import 'package:test_my_library/utils/app_format.dart';
import 'package:test_my_library/utils/decorations/input_decorations.dart';
import 'package:test_my_library/widgets/up_and_down_textfield/parrent_button.dart';

import 'error_text_field_recommendation.dart';

enum StockTextFieldType { price, volume }

const decimalDigit = 2;
const inputHeight = 50.0;

class UpAndDownTextField extends StatefulWidget {
  const UpAndDownTextField({
    Key? key,
    this.minValue,
    this.maxValue,
    this.title,
    this.type = StockTextFieldType.price,
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
  final StockTextFieldType? type;
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

  InputDecoration get _inputDecoration =>
      widget.decoration ?? InputDecorationCommon.baseModel();
  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController();
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
      final content = value.toFormatThousandSeparator();
      controller
        ..text = content
        ..selection = TextSelection.collapsed(offset: content.length);

      if (widget.onChanged != null) {
        widget.onChanged!(num.parse(content.reverseFromMoney));
      }
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
      final content = value.toFormatThousandSeparator();
      controller
        ..text = content
        ..selection = TextSelection.collapsed(offset: content.length);

      if (widget.onChanged != null) {
        widget.onChanged!(num.parse(content.reverseFromMoney));
      }
    } catch (e) {
      throw Exception('Value is not a number: $e');
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
    final isPrice = widget.type == StockTextFieldType.price;
    return IgnorePointer(
      ignoring: widget.disable,
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.only(left: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title ?? '',
              style: widget.titleStyle ??
                  const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black38),
            ),
            const SizedBox(
              height: 8,
            ),
            GestureDetector(
              onTap: () {
                myFocusNode.requestFocus();
              },
              child: Container(
                height: inputHeight,
                decoration: BoxDecoration(
                    color: hasErrorText ? Colors.red : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: hasErrorText ? Colors.red : Colors.grey)),
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      ParentButton(
                          onTap: onPressMinus,
                          child: widget.leftButton ??
                              const Icon(
                                Icons.minimize,
                                size: 20,
                              )),
                      Expanded(
                          child: Center(
                        child: IntrinsicWidth(
                          child: TextField(
                            focusNode: myFocusNode,
                            controller: controller,
                            style: getContentStyle(),
                            decoration: _inputDecoration,
                            keyboardType: isPrice
                                ? const TextInputType.numberWithOptions(
                                    decimal: true)
                                : TextInputType.number,
                            inputFormatters: widget.inputFormatters,
                            onChanged: onChangedText,
                          ),
                        ),
                      )),
                      ParentButton(
                          onTap: onPressPlus,
                          child: widget.rightButton ??
                              const Icon(
                                Icons.add,
                                size: 20,
                              ))
                    ]),
              ),
            ),
            Visibility(
              visible: hasErrorText && widget.isShowErrorText,
              child: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  ErrorTextFieldRecommendation(
                    widget.errorText,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formNum(String s) {
    return AppFormat.format(AppFormat.getNumber(s));
  }
}
