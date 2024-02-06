import 'package:flame/components.dart';
import 'package:simple_flame_game/components/components.dart';
import 'package:simple_flame_game/simple_game.dart';

class ObjectManager extends Component with HasGameRef<SimpleGame> {
  Player? player;
  Enemy? enemy;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    player = Player(
      key: ComponentKey.named('player'),
    );
    await game.add(player!);
    enemy = Enemy(
      onDeath: _spawnEnemy,
    );
    await game.add(enemy!);
  }

  @override
  void onRemove() {
    game.removeWhere((component) => component is Player || component is Enemy);
    super.onRemove();
  }

  void _spawnEnemy() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );
    if (parent != null && parent!.contains(this)) {
      enemy = Enemy(onDeath: _spawnEnemy);
      await game.add(enemy!);
    }
  }
}
