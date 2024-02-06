import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_flame_game/overlays/overlays.dart';
import 'package:simple_flame_game/simple_game.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
      ],
    );
    final game = SimpleGame();
    return SafeArea(
      child: GameWidget(
        game: game,
        overlayBuilderMap: <String, Widget Function(BuildContext, SimpleGame)>{
          ControlPanel.name: (context, game) => ControlPanel(game: game),
          GameScore.name: (context, game) => GameScore(game: game),
          MainMenu.name: (context, game) => MainMenu(game: game),
        },
      ),
    );
  }
}
