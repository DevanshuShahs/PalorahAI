import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final Color fillColor;
  final Color iconColor;
  final String hintText;
  final IconData? icon;
  final TextInputType textInputType;
  const PasswordInput({
    super.key,
    required this.textEditingController,
    this.fillColor = Colors.green,
    this.iconColor = Colors.green,
    this.isPass = false,
    required this.hintText,
    this.icon,
    required this.textInputType,
  });

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool isPass = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        style: const TextStyle(fontSize: 20),
        controller: widget.textEditingController,
        decoration: InputDecoration(
          suffixIcon: IconButton(
              icon: Icon(isPass ? Icons.visibility : Icons.visibility_off, color: widget.iconColor,),
              onPressed: () {
                setState(() {
                  isPass = !isPass;
                });
              }),
          prefixIcon: Icon(widget.icon, color: widget.iconColor),
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.black45, fontSize: 18),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(30),
          ),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.fillColor, width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
          filled: true,
          fillColor: widget.fillColor,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
        ),
        keyboardType: widget.textInputType,
        obscureText: isPass,
      ),
    );
  }
}
