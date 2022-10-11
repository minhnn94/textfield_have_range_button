import 'package:flutter/material.dart';

class InputDecorationCommon extends InputDecoration {
  factory InputDecorationCommon.baseModel() {
    return const InputDecorationCommon()
      ..copyWith(
        hintStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black38),
        hintText: '0',
        border: InputBorder.none,
        disabledBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: const EdgeInsets.only(
          right: 8,
          left: 8,
        ),
      );
  }

  const InputDecorationCommon();
}
