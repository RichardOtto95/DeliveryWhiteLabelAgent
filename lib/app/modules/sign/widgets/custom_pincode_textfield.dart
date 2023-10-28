import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../shared/utilities.dart';

class CustomPinCodeTextField extends StatefulWidget {
  final TextEditingController? controller;
  const CustomPinCodeTextField({Key? key, this.controller}) : super(key: key);

  @override
  _CustomPinCodeTextFieldState createState() => _CustomPinCodeTextFieldState();
}

class _CustomPinCodeTextFieldState extends State<CustomPinCodeTextField> {
  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(14),
        fieldHeight: 64,
        fieldWidth: 40,
        borderWidth: 1,
        activeFillColor: getColors(context).surface,
        selectedFillColor: getColors(context).primary.withOpacity(.9),
        inactiveFillColor: getColors(context).surface,
        activeColor: Colors.transparent,
        inactiveColor: Colors.transparent,
        selectedColor: getColors(context).primary.withOpacity(.9),
      ),
      boxShadows: const [
        BoxShadow(
          offset: Offset(0.5, 3),
          color: Color(0x30000000),
          blurRadius: 4,
        )
      ],
      enableActiveFill: true,
      appContext: context,
      length: 6,
      obscureText: false,
      animationType: AnimationType.fade,
      onChanged: (value) {
        print(value);
      },
    );
  }
}
