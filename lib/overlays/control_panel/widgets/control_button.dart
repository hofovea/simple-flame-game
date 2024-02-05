import 'package:flutter/material.dart';
import 'package:simple_flame_game/common/common.dart';
import 'package:simple_flame_game/overlays/control_panel/widgets/rotated_arrow.dart';

class ControlButton extends StatefulWidget {
  final VoidCallback? onTapDown;
  final VoidCallback? onTapUp;
  final VoidCallback? onDoubleTap;
  final Direction direction;

  const ControlButton({
    super.key,
    required this.direction,
    this.onTapDown,
    this.onTapUp,
    this.onDoubleTap,
  });

  @override
  State<ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<ControlButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTapDown: (pressDetails) {
          setState(() {
            isPressed = true;
          });
          widget.onTapDown?.call();
        },
        onTapUp: (pressDetails) {
          setState(() {
            isPressed = false;
          });
          widget.onTapUp?.call();
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
                RotatedArrow(
                  direction: widget.direction,
                  size: MediaQuery.sizeOf(context).width * 0.3,
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
