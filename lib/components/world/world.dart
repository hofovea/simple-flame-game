import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:simple_flame_game/simple_game.dart';

class World extends ParallaxComponent<SimpleGame> {
  @override
  Future<void> onLoad() async {
    parallax = await game.loadParallax(
      [
        ParallaxImageData('background/sky.jpg'),
      ],
      fill: LayerFill.height,
      repeat: ImageRepeat.repeat,
      baseVelocity: Vector2(0, -100),
      // velocityMultiplierDelta: Vector2(0, 0.2),
    );
  }
}
