import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final bool disabled;
  
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.disabled = false,
  });

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
        minimumSize: const Size(250, 60),
      ),
      onPressed: disabled ? null : onPressed,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: DefaultTextStyle(
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
          child: child,
        ),
      ),
    );
  }
}