import 'package:flutter/material.dart';

import '../../core/constants/colors.dart';


class CustomTextField extends StatefulWidget {
  final String? boxname;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final double? trailingIconSize;
  final Color? trailingIconColor;
  final double? height;
  final double? width;
  final bool readOnly;
  final double? textFieldHeight;
  final VoidCallback? onTrailingIconTap;
  final bool isEditable;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Color? hintTextColor;

  const CustomTextField({
    Key? key,
    this.boxname,
    this.hintText = '',
    this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.leadingIcon,
    this.trailingIcon,
    this.trailingIconSize = 24.0,
    this.trailingIconColor = Colors.black,
    this.height,
    this.width,
    this.onChanged,
    this.textFieldHeight = 50.0,
    this.onTrailingIconTap,
    this.isEditable = true,
    this.validator,
    this.readOnly = false,
    this.hintTextColor,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.boxname != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.boxname!,
              style: const TextStyle(
                fontSize: 12,
                color: greyFormColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        SizedBox(
          width: widget.width,
          height: 48.0,
          child: TextFormField(
            validator: widget.validator,
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.isPassword ? _isObscured : false,
            readOnly: widget.readOnly,
            enabled: widget.isEditable,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: widget.hintTextColor ?? greyFormColor,
                height: 1.5,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              fillColor: colorWhite,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: greyBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: greyBorder, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: greyBorder, width: 1),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              errorStyle: const TextStyle(height: 0.01),
              prefixIcon: widget.leadingIcon != null
                  ? Icon(widget.leadingIcon, color: Colors.black, size: 20)
                  : null,
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.trailingIcon != null)
                    GestureDetector(
                      onTap: widget.onTrailingIconTap,
                      child: Icon(
                        widget.trailingIcon,
                        size: widget.trailingIconSize,
                        color: widget.trailingIconColor,
                      ),
                    ),
                  if (widget.isPassword)
                    IconButton(
                      icon: Icon(
                        _isObscured
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    ),
                ],
              ),
            ),
            style: TextStyle(height: widget.height, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
