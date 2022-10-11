import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:textfield_have_range_button/utils/decorations/input_decorations.dart';
import 'package:textfield_have_range_button/widgets/base/parrent_button.dart';

import 'error_text_field_recommendation.dart';

enum StockTextFieldType { price, volume }

const decimalDigit = 2;
const inputHeight = 50.0;

class TextFieldBase extends StatefulWidget {
  const TextFieldBase({
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
    this.onLeftAction,
    this.onRightAction,
  }) : super(key: key);

  final String? title;
  final TextEditingController? controller;
  final StockTextFieldType? type;
  final EdgeInsetsGeometry? padding;
  final Function(String)? onChanged;
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
  final Function()? onLeftAction;
  final Function()? onRightAction;

  @override
  State<TextFieldBase> createState() => _TextFieldBaseState();
}

class _TextFieldBaseState extends State<TextFieldBase> {
  bool get hasErrorText => widget.errorText.isNotEmpty;
  final FocusNode myFocusNode = FocusNode();
  late final TextEditingController controller;

  InputDecoration get _inputDecoration =>
      widget.decoration ?? InputDecorationCommon.baseModel();
  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    controller.dispose();
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
                          onTap: widget.onLeftAction,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: widget.leftButton ??
                                const Icon(
                                  Icons.remove,
                                  size: 20,
                                ),
                          )),
                      Expanded(
                          child: Center(
                        child: IntrinsicWidth(
                          child: TextField(
                            focusNode: myFocusNode,
                            controller: controller,
                            style: widget.titleStyle,
                            decoration: _inputDecoration,
                            keyboardType: isPrice
                                ? const TextInputType.numberWithOptions(
                                    decimal: true)
                                : TextInputType.number,
                            inputFormatters: widget.inputFormatters,
                            onChanged: widget.onChanged,
                          ),
                        ),
                      )),
                      ParentButton(
                          onTap: widget.onRightAction,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: widget.rightButton ??
                                const Icon(
                                  Icons.add,
                                  size: 20,
                                ),
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
}
