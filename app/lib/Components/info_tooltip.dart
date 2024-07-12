import 'package:flutter/material.dart';

class InfoTooltip extends StatelessWidget {
  final String message;

  const InfoTooltip({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      
      message: message,
      child: const Icon(Icons.info_outline, size: 16),
    );
  }
}
