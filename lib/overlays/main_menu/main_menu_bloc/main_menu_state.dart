part of 'main_menu_bloc.dart';

@freezed
class MainMenuState with _$MainMenuState {
  const factory MainMenuState.mainMenu() = _MainMenu;
  const factory MainMenuState.settings(ControlType controlType) = _Settings;
}
