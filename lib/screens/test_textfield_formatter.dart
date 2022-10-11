import 'package:flutter/material.dart';
import 'package:test_my_library/widgets/up_and_down_textfield/up_and_down_textfield.dart';
import 'package:textfield_pattern_formatter/textfield_pattern_formatter.dart';

class TestTextFieldFormatter extends StatefulWidget {
  const TestTextFieldFormatter({Key? key}) : super(key: key);

  @override
  State<TestTextFieldFormatter> createState() => _TestTextFieldFormatterState();
}

class _TestTextFieldFormatterState extends State<TestTextFieldFormatter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Test Textfield formatter'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            inputFormatters: [ThousandSeparatorDecimalFormatter()],
          ),
          const UpAndDownTextField(),
        ],
      ),
    );
  }
}
