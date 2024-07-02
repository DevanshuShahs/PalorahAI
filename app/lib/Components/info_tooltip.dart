import 'package:flutter/material.dart';

class InfoTooltip extends StatelessWidget {
  final String message;

  const InfoTooltip({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      
      message: message,
      child: Icon(Icons.info_outline, size: 16),
    );
  }
}
