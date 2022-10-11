import 'package:flutter/material.dart';

class ParentButton extends StatelessWidget {
  const ParentButton({
    Key? key,
    required this.child,
    this.onTap,
  }) : super(key: key);
  final Function()? onTap;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: child,
    );
  }
}
