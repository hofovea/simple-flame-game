part of 'main_menu_bloc.dart';

@freezed
class MainMenuEvent with _$MainMenuEvent {
  const factory MainMenuEvent.toMainMenu() = _ToMainMenu;

  const factory MainMenuEvent.toSettings() = _ToSettings;

  const factory MainMenuEvent.startGame() = _StartGame;

  const factory MainMenuEvent.pickLeftHandedControl() = _PickLeftHandedControl;

  const factory MainMenuEvent.pickRightHandedControl() = _PickRightHandedControl;
}
