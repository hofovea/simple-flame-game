import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_flame_game/overlays/main_menu/main_menu_bloc/main_menu_bloc.dart';
import 'package:simple_flame_game/overlays/main_menu/widgets/widgets.dart';
import 'package:simple_flame_game/simple_game.dart';

class MainMenu extends StatelessWidget {
  static const String name = 'mainMenu';
  final SimpleGame game;

  const MainMenu({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue.withOpacity(0.5),
      child: BlocProvider(
        create: (context) => MainMenuBloc(game),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocBuilder<MainMenuBloc, MainMenuState>(
            builder: (context, state) {
              return state.when(
                mainMenu: () => const Menu(),
                settings: (controlType) => Settings(controlType: controlType),
              );
            },
          ),
        ),
      ),
    );
  }
}
