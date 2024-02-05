import 'package:flutter/material.dart';
import 'package:simple_flame_game/common/common.dart';
import 'package:simple_flame_game/components/components.dart';
import 'package:simple_flame_game/overlays/control_panel/widgets/control_button.dart';
import 'package:simple_flame_game/overlays/control_panel/widgets/shoot_button.dart';
import 'package:simple_flame_game/simple_game.dart';

class ControlPanel extends StatelessWidget {
  static const String name = 'controlPanel';
  final SimpleGame game;

  const ControlPanel({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final controlType = game.gameManager.currentControlType;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          visible: controlType == ControlType.leftHanded,
          child: ShootButton(
            onTap: (game.findByKeyName('player') as Player?)?.shoot,
          ),
        ),
        ControlButton(
          onTapDown: (game.findByKeyName('player') as Player?)?.moveLeft,
          onTapUp: (game.findByKeyName('player') as Player?)?.stopMove,
          direction: Direction.left,
        ),
        ControlButton(
          onTapDown: (game.findByKeyName('player') as Player?)?.moveRight,
          onTapUp: (game.findByKeyName('player') as Player?)?.stopMove,
          direction: Direction.right,
        ),
        Visibility(
          visible: controlType == ControlType.rightHanded,
          child: ShootButton(
            onTap: (game.findByKeyName('player') as Player?)?.shoot,
          ),
        ),
      ],
    );
  }
}
