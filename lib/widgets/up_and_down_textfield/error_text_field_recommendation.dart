import 'package:flutter/material.dart';

class ErrorTextFieldRecommendation extends StatelessWidget {
  const ErrorTextFieldRecommendation(
    this.content, {
    Key? key,
    this.padding,
  }) : super(key: key);
  final String content;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        content,
        style: const TextStyle(
            fontWeight: FontWeight.w500, fontSize: 12, color: Colors.red),
      ),
    );
  }
}
