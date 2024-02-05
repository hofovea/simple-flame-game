import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:simple_flame_game/common/common.dart' show MissileState, MissileType;
import 'package:simple_flame_game/components/components.dart';
import 'package:simple_flame_game/simple_game.dart';

class Missile extends SpriteAnimationGroupComponent<MissileState>
    with CollisionCallbacks, HasGameRef<SimpleGame> {
  static const double _defaultSpeed = 800;

  final MissileType type;
  final Vector2 startPosition;
  final double _speed = _defaultSpeed;
  late final SpriteAnimationTicker _explosionTicker;

  bool get isFriendly => type == MissileType.friendly;

  bool get isEnemy => type == MissileType.enemy;

  Missile({required this.type, required this.startPosition}) : super(position: startPosition);

  factory Missile.friendly({required Vector2 startPosition}) => Missile(
        type: MissileType.friendly,
        startPosition: startPosition,
      );

  factory Missile.enemy({required Vector2 startPosition}) => Missile(
        type: MissileType.enemy,
        startPosition: startPosition,
      );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _explosionTicker = (await _loadExplosionAnimation()).createTicker();

    animations = <MissileState, SpriteAnimation>{
      MissileState.flight: await _loadFlightAnimation(),
      MissileState.explosion: _explosionTicker.spriteAnimation,
    };
    current = MissileState.flight;
    _explosionTicker.onComplete = () {
      parent?.remove(this);
    };

    final widthToHeightRatio = width / height;
    height = 25;
    width = height * widthToHeightRatio;
    anchor = Anchor.center;
    await add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    _explosionTicker.update(dt);
    if (isEnemy) {
      position.y += _speed * dt;
    } else {
      position.y -= _speed * dt;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (current != MissileState.explosion) {
      if (other is Player) {
        _playerCollisionHandler(intersectionPoints);
      } else if (other is ScreenHitbox) {
        _screenCollisionHandler(intersectionPoints);
      } else if (other is Enemy) {
        _enemyCollisionHandler(intersectionPoints);
      }

      // const double explosionAspectRatio = 2 / 3;
      // size = Vector2(60, 60 * explosionAspectRatio);
      // _speed = 0;
      // current = MissileState.explosion;
      // animations?[current]?.loop = false;
    }
  }

  Future<SpriteAnimation> _loadFlightAnimation() async {
    final images = Images(prefix: 'assets/');
    List<SpriteAnimationFrame> frames = [];
    const int animationLength = 6;
    for (int i = 0; i < animationLength; i++) {
      final sprite = await Sprite.load('missiles/0${i}_missiles.png', images: images);
      frames.add(SpriteAnimationFrame(sprite, 0.1));
    }
    return SpriteAnimation(frames);
  }

  Future<SpriteAnimation> _loadExplosionAnimation() async {
    final images = Images(prefix: 'assets/');
    List<SpriteAnimationFrame> frames = [];
    const int animationLength = 6;
    for (int i = 0; i < animationLength; i++) {
      final sprite = await Sprite.load('explosion/0${i}_explosion.png', images: images);
      frames.add(SpriteAnimationFrame(sprite, 0.07));
    }
    return SpriteAnimation(frames);
  }

  void _screenCollisionHandler(Set<Vector2> intersectionPoints) {
    parent?.remove(this);
  }

  void _enemyCollisionHandler(Set<Vector2> intersectionPoints) {
    if (isFriendly) {
      game.gameManager.increaseScore();
      parent?.remove(this);
    }
  }

  void _playerCollisionHandler(Set<Vector2> intersectionPoints) {
    if (isEnemy) {
      parent?.remove(this);
    }
  }
}
