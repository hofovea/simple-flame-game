import 'package:flutter/material.dart';
import 'package:simple_flame_game/common/common.dart';

class RotatedArrow extends StatelessWidget {
  final double size;
  final Direction direction;

  const RotatedArrow({
    super.key,
    required this.direction,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.withOpacity(0.5),
      child: RotatedBox(
        quarterTurns: switch (direction) {
          Direction.up => 1,
          Direction.down => 3,
          Direction.left => 0,
          Direction.right => 2,
        },
        child: Icon(
          Icons.arrow_back_sharp,
          color: Colors.red,
          size: size,
        ),
      ),
    );
  }
}
