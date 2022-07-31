// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class AppTextField extends StatefulWidget {
  final String hint;
  final Widget? leftIcon, rightIcon;
  final bool hideText;
  final TextInputAction? action;
  final TextInputType? keyboard;
  final TextEditingController? controller;
  final VoidCallback? onChanged;
  final String? Function(String?)? validator;

  AppTextField({
    Key? key,
    this.validator,
    this.onChanged,
    this.leftIcon,
    this.rightIcon,
    this.action,
    this.keyboard,
    this.hideText = false,
    required this.hint,
    this.controller,
  }) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool hideText = false;
  void hidPwd() {
    setState(() {
      hideText = !hideText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: widget.validator,
        onEditingComplete: widget.onChanged,
        controller: widget.controller,
        textInputAction: widget.action ?? TextInputAction.next,
        keyboardType: widget.keyboard,
        autofocus: true,
        obscureText: hideText,
        decoration: InputDecoration(
          label: Text(widget.hint, style: GoogleFonts.roboto()),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          prefixIcon: widget.leftIcon,
          suffixIcon: widget.hideText
              ? GestureDetector(
                  onTap: hidPwd,
                  child:
                      Icon(hideText ? Icons.visibility_off : Icons.visibility),
                )
              : widget.rightIcon,
        ),
      ),
    );
  }
}
