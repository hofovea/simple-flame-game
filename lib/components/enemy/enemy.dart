import 'dart:math';

import 'package:flame/cache.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:simple_flame_game/common/common.dart' show EnemyState;
import 'package:simple_flame_game/components/missile/missile.dart';
import 'package:simple_flame_game/simple_game.dart';

class Enemy extends SpriteAnimationGroupComponent<EnemyState>
    with CollisionCallbacks, HasGameRef<SimpleGame> {
  static const double _speed = 300;
  static const double _defaultShootInterval = 1.5;

  final _random = Random();
  final VoidCallback onDeath;
  late final SpriteAnimationTicker _explosionTicker;
  late final Timer _timer;

  int _moveDirection = 1;

  Enemy({required this.onDeath});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _setupAnimations();
    final widthToHeightRatio = width / height;
    height = 100;
    width = height * widthToHeightRatio;
    position.x = _random.nextInt((game.size.x - width).toInt()).toDouble();
    position.y = height + _random.nextInt(game.size.y ~/ 2 - height.toInt()).toDouble();
    anchor = Anchor.center;
    flipVertically();
    await add(RectangleHitbox());
    add(
      ColorEffect(
        Colors.red,
        EffectController(duration: 0),
        opacityTo: 0.3,
      ),
    );

    _timer = Timer(_defaultShootInterval, repeat: true, onTick: _shoot);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer.update(dt);
    _explosionTicker.update(dt);
    if (current != EnemyState.explosion) {
      position.x += _moveDirection * _speed * dt;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (current != EnemyState.explosion) {
      if (other is ScreenHitbox) {
        _screenCollisionHandler(intersectionPoints);
      } else if (other is Missile) {
        _missileCollisionHandler(intersectionPoints, other);
      }
    }
  }

  void _shoot() {
    game.add(
      Missile.enemy(startPosition: position),
    );
  }

  Future<void> _setupAnimations() async {
    _explosionTicker = (await _loadExplosionAnimation()).createTicker();
    animations = <EnemyState, SpriteAnimation>{
      EnemyState.right: await _loadLeftAnimation(),
      EnemyState.left: await _loadRightAnimation(),
      EnemyState.explosion: _explosionTicker.spriteAnimation,
    };
    _explosionTicker.onComplete = () {
      onDeath();
      parent?.remove(this);
    };
    current = EnemyState.right;
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
    _moveDirection = -_moveDirection;
    if (position.x - width / 2 <= 0) {
      current = EnemyState.right;
      position.x = width / 2;
    } else {
      current = EnemyState.left;
      position.x = game.size.x - width / 2;
    }
  }

  void _missileCollisionHandler(Set<Vector2> intersectionPoints, Missile missile) {
    // onDeath();
    // parent?.remove(this);
    if (missile.isFriendly) {
      const double explosionAspectRatio = 2 / 3;
      size = Vector2(100, 100 * explosionAspectRatio);
      current = EnemyState.explosion;
      animations?[current]?.loop = false;
    }
  }
}
