import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_flame_game/common/common.dart' show ControlType;
import 'package:simple_flame_game/overlays/main_menu/main_menu_bloc/main_menu_bloc.dart';

class Settings extends StatelessWidget {
  final ControlType controlType;

  const Settings({super.key, required this.controlType});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            'Pick your control style:',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          InkWell(
            splashColor: Colors.blue,
            highlightColor: Colors.blue,
            onTap: () => BlocProvider.of<MainMenuBloc>(context).add(
              const MainMenuEvent.pickRightHandedControl(),
            ),
            child: ColoredBox(
              color: switch (controlType) {
                ControlType.leftHanded => Colors.transparent,
                ControlType.rightHanded => Colors.blueGrey.withOpacity(0.5),
              },
              child: SvgPicture.asset('assets/common/right_handed.svg'),
            ),
          ),
          InkWell(
            splashColor: Colors.blue,
            highlightColor: Colors.blue,
            onTap: () => BlocProvider.of<MainMenuBloc>(context).add(
              const MainMenuEvent.pickLeftHandedControl(),
            ),
            child: ColoredBox(
              color: switch (controlType) {
                ControlType.leftHanded => Colors.blueGrey.withOpacity(0.5),
                ControlType.rightHanded => Colors.transparent,
              },
              child: SvgPicture.asset('assets/common/left_handed.svg'),
            ),
          ),
          InkWell(
            splashColor: Colors.blue,
            highlightColor: Colors.blue,
            onTap: () => BlocProvider.of<MainMenuBloc>(context).add(
              const MainMenuEvent.toMainMenu(),
            ),
            child: const Text(
              'Back',
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
