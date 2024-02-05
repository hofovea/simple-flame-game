import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:simple_flame_game/common/common.dart';
import 'package:simple_flame_game/managers/managers.dart' show ObjectManager;
import 'package:simple_flame_game/overlays/overlays.dart';
import 'package:simple_flame_game/simple_game.dart';

class GameManager extends Component with HasGameRef<SimpleGame> {
  final ValueNotifier<int> score = ValueNotifier(0);

  ObjectManager? _objectManager;
  ControlType _selectedControlType = ControlType.leftHanded;

  ControlType get currentControlType => _selectedControlType;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    toMainMenu();
  }

  void increaseScore() => score.value++;

  Future<void> startGame() async {
    game.overlays.clear();
    _objectManager = ObjectManager();
    await add(_objectManager!);
    game.overlays.add(ControlPanel.name);
    game.overlays.add(GameScore.name);
  }

  void toMainMenu() {
    _resetGame();
    game.overlays.add(MainMenu.name);
  }

  void pauseGame() => game.pauseEngine();

  void resumeGame() => game.resumeEngine();

  void setLeftHandedControl() => _selectedControlType = ControlType.leftHanded;

  void setRightHandedControl() => _selectedControlType = ControlType.rightHanded;

  void _resetGame() {
    game.overlays.clear();
    score.value = 0;
    if (_objectManager != null) {
      remove(_objectManager!);
    }
  }
}
