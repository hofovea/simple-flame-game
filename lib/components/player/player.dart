import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:simple_flame_game/common/common.dart' show PlayerState;
import 'package:simple_flame_game/components/missile/missile.dart';
import 'package:simple_flame_game/simple_game.dart';

class Player extends SpriteAnimationGroupComponent<PlayerState>
    with CollisionCallbacks, HasGameRef<SimpleGame> {
  static const double _defaultShootInterval = 3;
  static const double _defaultMoveSpeed = 200;

  late final SpriteAnimationTicker _explosionTicker;
  late final Timer _timer;

  bool canShoot = true;

  Player({ComponentKey? key}) : super(key: key);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _setupAnimation();
    position.x = game.size.x / 2;
    position.y = game.size.y * 0.8;
    final widthToHeightRatio = width / height;
    height = 100;
    width = height * widthToHeightRatio;
    anchor = Anchor.center;
    await add(RectangleHitbox());

    _timer = Timer(
      _defaultShootInterval,
      repeat: true,
      onTick: () {
        canShoot = true;
      },
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer.update(dt);
    if (current != null && current != PlayerState.none && current != PlayerState.dead) {
      final tickOffset = switch (current!) {
        PlayerState.right => Vector2(_defaultMoveSpeed * dt, 0),
        PlayerState.left => Vector2(-_defaultMoveSpeed * dt, 0),
        PlayerState.none => Vector2.zero(),
        PlayerState.dead => Vector2.zero(),
      };
      position += tickOffset;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is ScreenHitbox) {
      _screenCollisionHandler(intersectionPoints);
    } else if (other is Missile) {
      if (other.isEnemy) {
        game.gameManager.toMainMenu();
      }
    }
  }

  void shoot() {
    if (canShoot) {
      game.add(
        Missile.friendly(startPosition: position),
      );
      canShoot = false;
    }
  }

  void moveRight() {
    current = PlayerState.right;
  }

  void moveLeft() {
    current = PlayerState.left;
  }

  void stopMove() {
    current = PlayerState.none;
  }

  Future<void> _setupAnimation() async {
    _explosionTicker = (await _loadExplosionAnimation()).createTicker();
    animations = <PlayerState, SpriteAnimation>{
      PlayerState.none: await _loadNoneAnimation(),
      PlayerState.left: await _loadLeftAnimation(),
      PlayerState.right: await _loadRightAnimation(),
      PlayerState.dead: _explosionTicker.spriteAnimation,
    };
    _explosionTicker.onComplete = () {};
    current = PlayerState.none;
  }

  Future<SpriteAnimation> _loadNoneAnimation() async {
    final images = Images(prefix: 'assets/jet/');
    List<SpriteAnimationFrame> frames = [];
    const int animationLength = 2;
    for (int i = animationLength; i > 0; i--) {
      final sprite = await Sprite.load('0${i - 1}_jet.png', images: images);
      frames.add(SpriteAnimationFrame(sprite, 0.3));
    }
    for (int i = 0; i < animationLength; i++) {
      final sprite = await Sprite.load('0${i + 1}_jet.png', images: images);
      frames.add(SpriteAnimationFrame(sprite, 0.3));
    }
    return SpriteAnimation(frames);
  }

  Future<SpriteAnimation> _loadLeftAnimation() async {
    final images = Images(prefix: 'assets/jet/');
    List<SpriteAnimationFrame> frames = [];
    const int animationLength = 2;
    for (int i = 0; i < animationLength; i++) {
      final sprite = await Sprite.load('0${i}_jet.png', images: images);
      frames.add(SpriteAnimationFrame(sprite, 0.4));
    }
    return SpriteAnimation(frames);
  }

  Future<SpriteAnimation> _loadRightAnimation() async {
    final images = Images(prefix: 'assets/jet/');
    List<SpriteAnimationFrame> frames = [];
    const int animationLength = 2;
    for (int i = animationLength; i > 0; i--) {
      final sprite = await Sprite.load('0${i}_jet.png', images: images);
      frames.add(SpriteAnimationFrame(sprite, 0.4));
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
    current = PlayerState.none;
    if (position.x - width / 2 <= 0) {
      position.x = width / 2;
    } else {
      position.x = game.size.x - width / 2;
    }
  }
}
