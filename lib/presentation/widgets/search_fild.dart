// import 'package:flutter/material.dart';

// class SearchField extends StatefulWidget {
//   final String? boxname;
//   final String hintText;
//   final TextEditingController? controller;
//   final TextInputType keyboardType;
//   final bool isPassword;
//   final IconData? leadingIcon;
//   final IconData? suffixIcon; // Added suffix icon as a parameter
//   final double? height;
//   final double? width;

//   const SearchField({
//     Key? key,
//     this.boxname,
//     this.hintText = '',
//     this.controller,
//     this.keyboardType = TextInputType.text,
//     this.isPassword = false,
//     this.leadingIcon,
//     this.suffixIcon, // Added suffix icon to the constructor
//     this.height,
//     this.width,
//   }) : super(key: key);

//   @override
//   _SearchFieldState createState() => _SearchFieldState();
// }

// class _SearchFieldState extends State<SearchField> {
//   bool _isObscured = true;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (widget.boxname != null)
//           Padding(
//             padding: const EdgeInsets.only(bottom: 8.0),
//             child: Text(
//               widget.boxname!,
//               style: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         Container(
//           width: widget.width,
//           height: widget.height,
//           decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black12,
//                 spreadRadius: 0,
//                 blurRadius: 1,
//                 offset: Offset(0, 2),
//               ),
//             ],
//           ),
//           child: TextFormField(
//             controller: widget.controller,
//             keyboardType: widget.keyboardType,
//             obscureText: widget.isPassword ? _isObscured : false,
//             decoration: InputDecoration(
//               hintText: widget.hintText,
//               hintStyle: const TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),
//               contentPadding: const EdgeInsets.all(20),
//               fillColor: Color.fromARGB(255, 249, 248, 248),
//               filled: true,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: const BorderSide(color: Color(0x40F4F4F4)),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(5),
//                 borderSide: const BorderSide(
//                   color: Color(0x40F4F4F4),
//                   width: 2,
//                 ),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: const BorderSide(
//                   color: Color(0x40F4F4F4),
//                   width: 2,
//                 ),
//               ),
//               prefixIcon: widget.leadingIcon != null
//                   ? Icon(
//                       widget.leadingIcon,
//                       color: Colors.black,
//                     )
//                   : null,
//               suffixIcon: widget.isPassword
//                   ? IconButton(
//                       icon: Icon(
//                         _isObscured ? Icons.visibility_off : Icons.visibility,
//                         color: Colors.black,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _isObscured = !_isObscured;
//                         });
//                       },
//                     )
//                   : (widget.suffixIcon !=
//                           null // Display suffix icon for non-password fields
//                       ? Icon(widget.suffixIcon, color: Colors.black)
//                       : null),
//             ),
//             onChanged: (value) {
//               setState(() {});
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final String? boxname;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final IconData? leadingIcon;
  final IconData? suffixIcon; // Added suffix icon as a parameter
  final double? height;
  final double? width;
  final Function(String)? onChanged;
  const SearchField({
    Key? key,
    this.boxname,
    this.hintText = '',
    this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.leadingIcon,
    this.suffixIcon, // Added suffix icon to the constructor
    this.height,
    this.width,
    this.onChanged,
  }) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
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
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        SizedBox(
          width: widget.width,
          height: widget.height,
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.isPassword ? _isObscured : false,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              contentPadding: const EdgeInsets.all(20),
              fillColor: const Color.fromARGB(255, 249, 248, 248),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8), // Rounded corners
                borderSide: const BorderSide(
                  color: Color(0xFFE0E0E0), // Light shade for the border
                  width: 1, // Thin border
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFBDBDBD), // Slightly darker border on focus
                  width: 1, // Thin border
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFE0E0E0), // Light shade for the border
                  width: 1, // Thin border
                ),
              ),
              prefixIcon: widget.leadingIcon != null
                  ? Icon(
                widget.leadingIcon,
                color: Colors.black,
              )
                  : null,
              suffixIcon: widget.isPassword
                  ? IconButton(
                icon: Icon(
                  _isObscured ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _isObscured = !_isObscured;
                  });
                },
              )
                  : (widget.suffixIcon !=
                  null // Display suffix icon for non-password fields
                  ? Icon(widget.suffixIcon, color: Colors.black)
                  : null),
            ),
            onChanged: widget.onChanged,
          ),
        ),
      ],
    );
  }
}
