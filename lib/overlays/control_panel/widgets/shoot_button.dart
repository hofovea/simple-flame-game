import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ShootButton extends StatefulWidget {
  final VoidCallback? onTap;

  const ShootButton({
    super.key,
    this.onTap,
  });

  @override
  State<ShootButton> createState() => _ShootButtonState();
}

class _ShootButtonState extends State<ShootButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTapDown: (pressDetails) {
          setState(() {
            isPressed = true;
          });
        },
        onTapUp: (pressDetails) {
          setState(() {
            isPressed = false;
          });
          widget.onTap?.call();
        },
        child: AnimatedOpacity(
          opacity: isPressed ? 1.0 : 0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastEaseInToSlowEaseOut,
          child: ColoredBox(
            color: Colors.grey.withOpacity(0.25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SvgPicture.asset(
                  'assets/common/scope.svg',
                  width: MediaQuery.sizeOf(context).width * 0.3,
                  height: MediaQuery.sizeOf(context).width * 0.3,
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
