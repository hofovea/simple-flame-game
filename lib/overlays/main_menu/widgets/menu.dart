import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_flame_game/overlays/main_menu/main_menu_bloc/main_menu_bloc.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            splashColor: Colors.blue,
            highlightColor: Colors.blue,
            onTap: () async {
              BlocProvider.of<MainMenuBloc>(context).add(
                const MainMenuEvent.startGame(),
              );
            },
            child: const Text(
              'Start',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          InkWell(
            splashColor: Colors.blue,
            highlightColor: Colors.blue,
            onTap: () async {
              BlocProvider.of<MainMenuBloc>(context).add(
                const MainMenuEvent.toSettings(),
              );
            },
            child: const Text(
              'Settings',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
