import 'package:flutter/material.dart';
import 'package:simple_flame_game/simple_game.dart';

class GameScore extends StatelessWidget {
  static const String name = 'gameScore';
  final SimpleGame game;

  const GameScore({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ValueListenableBuilder<int>(
          valueListenable: game.gameManager.score,
          builder: (context, score, child) {
            return Text(
              score.toString(),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            );
          }),
    );
  }
}
