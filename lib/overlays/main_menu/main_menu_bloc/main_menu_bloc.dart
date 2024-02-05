import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_flame_game/common/common.dart' show ControlType;
import 'package:simple_flame_game/simple_game.dart';

part 'main_menu_event.dart';

part 'main_menu_state.dart';

part 'main_menu_bloc.freezed.dart';

class MainMenuBloc extends Bloc<MainMenuEvent, MainMenuState> {
  late final SimpleGame _game;

  MainMenuBloc(SimpleGame game) : super(const MainMenuState.mainMenu()) {
    _game = game;
    on<MainMenuEvent>(
      (event, emit) async {
        await event.when(
          toMainMenu: () {
            emit(
              const MainMenuState.mainMenu(),
            );
          },
          toSettings: () {
            emit(
              MainMenuState.settings(_game.gameManager.currentControlType),
            );
          },
          startGame: () async {
            await _game.gameManager.startGame();
          },
          pickLeftHandedControl: () {
            _game.gameManager.setLeftHandedControl();
            emit(
              MainMenuState.settings(_game.gameManager.currentControlType),
            );
          },
          pickRightHandedControl: () {
            _game.gameManager.setRightHandedControl();
            emit(
              MainMenuState.settings(_game.gameManager.currentControlType),
            );
          },
        );
      },
    );
  }
}
