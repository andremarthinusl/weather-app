import 'dart:math';
import 'package:flutter/material.dart';
import 'package:weather_repository/weather_repository.dart';

class WeatherParticles extends StatefulWidget {
  final WeatherCondition condition;

  const WeatherParticles({super.key, required this.condition});

  @override
  State<WeatherParticles> createState() => _WeatherParticlesState();
}

class _WeatherParticlesState extends State<WeatherParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _controller.addListener(() {
      _updateParticles();
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(WeatherParticles oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.condition != widget.condition) {
      _particles.clear(); // Reset on weather change
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateParticles() {
    final size = MediaQuery.of(context).size;
    final int targetCount = _getTargetParticleCount();

    // Spawn new particles
    if (_particles.length < targetCount && _random.nextDouble() < 0.3) {
      _particles.add(_spawnParticle(size));
    }

    // Update existing particles
    for (var particle in _particles) {
      particle.update();
    }

    // Remove particles out of bounds
    _particles.removeWhere((p) => p.isOutOfBounds(size));
  }

  int _getTargetParticleCount() {
    switch (widget.condition) {
      case WeatherCondition.rainy:
        return 100;
      case WeatherCondition.snowy:
        return 60;
      case WeatherCondition.cloudy:
        return 10; // Few clouds
      default:
        return 0;
    }
  }

  Particle _spawnParticle(Size size) {
    switch (widget.condition) {
      case WeatherCondition.rainy:
        return RainParticle(
          x: _random.nextDouble() * size.width,
          y: -20,
          speed: 15 + _random.nextDouble() * 10,
        );
      case WeatherCondition.snowy:
        return SnowParticle(
          x: _random.nextDouble() * size.width,
          y: -20,
          speedY: 2 + _random.nextDouble() * 3,
          speedX: -1 + _random.nextDouble() * 2,
          radius: 2 + _random.nextDouble() * 3,
        );
      case WeatherCondition.cloudy:
        return CloudParticle(
          x: size.width + 50,
          y: _random.nextDouble() * (size.height / 3),
          speedX: -0.5 - _random.nextDouble(),
          radius: 40 + _random.nextDouble() * 60,
        );
      default:
        return RainParticle(x: 0, y: 0, speed: 0); // Fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.condition == WeatherCondition.clear ||
        widget.condition == WeatherCondition.unknown) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: CustomPaint(
        painter: ParticlePainter(_particles, widget.condition),
        size: Size.infinite,
      ),
    );
  }
}

abstract class Particle {
  double x;
  double y;
  Particle(this.x, this.y);

  void update();
  bool isOutOfBounds(Size size);
  void draw(Canvas canvas, Paint paint);
}

class RainParticle extends Particle {
  double speed;
  RainParticle({required double x, required double y, required this.speed}) : super(x, y);

  @override
  void update() {
    y += speed;
    x += speed * 0.2; // Slight wind effect
  }

  @override
  bool isOutOfBounds(Size size) => y > size.height;

  @override
  void draw(Canvas canvas, Paint paint) {
    paint.color = Colors.white.withOpacity(0.4);
    paint.strokeWidth = 2;
    canvas.drawLine(Offset(x, y), Offset(x + speed * 0.2, y + speed), paint);
  }
}

class SnowParticle extends Particle {
  double speedY;
  double speedX;
  double radius;
  double time = 0;

  SnowParticle({
    required double x,
    required double y,
    required this.speedY,
    required this.speedX,
    required this.radius,
  }) : super(x, y);

  @override
  void update() {
    time += 0.05;
    y += speedY;
    x += speedX + sin(time) * 0.5; // Fluttering effect
  }

  @override
  bool isOutOfBounds(Size size) => y > size.height || x < -20 || x > size.width + 20;

  @override
  void draw(Canvas canvas, Paint paint) {
    paint.color = Colors.white.withOpacity(0.8);
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, y), radius, paint);
  }
}

class CloudParticle extends Particle {
  double speedX;
  double radius;

  CloudParticle({
    required double x,
    required double y,
    required this.speedX,
    required this.radius,
  }) : super(x, y);

  @override
  void update() {
    x += speedX;
  }

  @override
  bool isOutOfBounds(Size size) => x < -radius * 2;

  @override
  void draw(Canvas canvas, Paint paint) {
    paint.color = Colors.white.withOpacity(0.15); // Very faint clouds
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, y), radius, paint);
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final WeatherCondition condition;
  final Paint _paint = Paint();

  ParticlePainter(this.particles, this.condition);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      particle.draw(canvas, _paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
}
