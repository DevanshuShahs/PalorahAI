import 'package:flutter/material.dart';

class SpringingArrow extends StatefulWidget {
  const SpringingArrow({super.key});

  @override
  _SpringingArrowState createState() => _SpringingArrowState();
}

class _SpringingArrowState extends State<SpringingArrow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // Adjust duration as needed
    );

    _animation = Tween<double>(begin: 0, end: 50).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
    ));

    _startAnimation();
  }

  void _startAnimation() {
    _controller.forward().whenComplete(() {
      _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Stack(
          children: [
            Positioned(
              left: _animation.value,
              child: const Icon(
                Icons.arrow_forward,
                size: 36,
              ),
            ),
          ],
        );
      },
    );
  }
}