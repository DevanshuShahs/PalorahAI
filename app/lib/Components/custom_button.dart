import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  
  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        shadowColor: Colors.greenAccent,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        minimumSize: Size(250, 60),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: DefaultTextStyle(
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
          child: child,
        ),
      ),
    );
  }
}