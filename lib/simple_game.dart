import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/game.dart';
import 'package:simple_flame_game/managers/managers.dart';

import 'components/components.dart';

class SimpleGame extends FlameGame with HasCollisionDetection {
  late final GameManager _gameManager;

  GameManager get gameManager => _gameManager;

  World? _world;

  @override
  final images = Images(prefix: 'assets/');

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(ScreenHitbox());
    _world = World();
    await add(_world!);
    _gameManager = GameManager();
    await add(_gameManager);
  }
}
