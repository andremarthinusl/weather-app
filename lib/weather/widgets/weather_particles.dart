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
  double _time = 0;
  Size _cachedSize = const Size(400, 800);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..repeat();
    _controller.addListener(() {
      if (!mounted) return;
      _time += 0.016;
      _updateParticles();
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(WeatherParticles oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.condition != widget.condition) {
      _particles.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateParticles() {
    final size = _cachedSize;
    final int targetCount = _getTargetParticleCount();

    // Spawn new particles
    if (_particles.length < targetCount) {
      // Spawn slightly more aggressively if way below target
      int toSpawn = (targetCount - _particles.length) > 10 ? 5 : 1;
      for (int i = 0; i < toSpawn; i++) {
        _particles.add(_spawnParticle(size));
      }
    }

    // Update existing particles
    for (var particle in _particles) {
      particle.update(_time);
    }

    // Remove particles out of bounds or dead
    _particles.removeWhere((p) => p.isDead(size));
  }

  int _getTargetParticleCount() {
    switch (widget.condition) {
      case WeatherCondition.rainy:
        return 150; // Heavy rain
      case WeatherCondition.snowy:
        return 80;
      case WeatherCondition.cloudy:
        return 12; // Fluffy clouds
      case WeatherCondition.clear:
        return 20; // Sun glares/dust
      case WeatherCondition.unknown:
        return 30; // Blowing leaves
    }
  }

  Particle _spawnParticle(Size size) {
    switch (widget.condition) {
      case WeatherCondition.rainy:
        if (_random.nextDouble() < 0.005) {
          // Rare lightning flash
          return LightningParticle(size: size);
        }
        return RainParticle(
          x: _random.nextDouble() * size.width * 1.5 - size.width * 0.2,
          y: -50,
          speed: 20 + _random.nextDouble() * 15,
        );
      case WeatherCondition.snowy:
        return SnowParticle(
          x: _random.nextDouble() * size.width,
          y: -20,
          speedY: 2 + _random.nextDouble() * 4,
          speedX: -1.5 + _random.nextDouble() * 3,
          radius: 2 + _random.nextDouble() * 4,
        );
      case WeatherCondition.cloudy:
        return CloudParticle(
          x: size.width + 100,
          y: _random.nextDouble() * (size.height * 0.4),
          speedX: -0.3 - _random.nextDouble() * 0.5,
          scale: 0.5 + _random.nextDouble() * 1.5,
        );
      case WeatherCondition.clear:
        return SunDustParticle(
          x: _random.nextDouble() * size.width,
          y: _random.nextDouble() * size.height,
          radius: 1 + _random.nextDouble() * 3,
        );
      case WeatherCondition.unknown:
        return LeafParticle(
          x: size.width + 20,
          y: _random.nextDouble() * size.height,
          speedX: -3 - _random.nextDouble() * 4,
          speedY: -1 + _random.nextDouble() * 2,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    _cachedSize = MediaQuery.of(context).size;
    return IgnorePointer(
      child: CustomPaint(
        painter: ParticlePainter(_particles, widget.condition),
        size: Size.infinite,
      ),
    );
  }
}

abstract class Particle {
  void update(double time);
  bool isDead(Size size);
  void draw(Canvas canvas, Paint paint);
}

class RainParticle extends Particle {
  double x;
  double y;
  double speed;
  double length;
  double opacity;

  RainParticle({required this.x, required this.y, required this.speed})
      : length = speed * 0.8,
        opacity = (speed / 35).clamp(0.2, 0.6); // Faster rain is more opaque

  @override
  void update(double time) {
    y += speed;
    x += speed * 0.15; // Slanted rain due to wind
  }

  @override
  bool isDead(Size size) => y > size.height;

  @override
  void draw(Canvas canvas, Paint paint) {
    paint.color = Colors.white.withValues(alpha: opacity);
    paint.strokeWidth = speed * 0.08; // Faster rain is thicker (closer to camera)
    paint.strokeCap = StrokeCap.round;
    
    canvas.drawLine(
      Offset(x, y),
      Offset(x + speed * 0.15, y + length),
      paint,
    );
  }
}

class LightningParticle extends Particle {
  int life = 20;
  final int maxLife = 20;
  Size size;
  
  LightningParticle({required this.size});

  @override
  void update(double time) {
    life--;
  }

  @override
  bool isDead(Size size) => life <= 0;

  @override
  void draw(Canvas canvas, Paint paint) {
    // Double flash effect
    final flashFactor = (life > maxLife * 0.7) 
        ? 1.0 
        : (life > maxLife * 0.4 && life < maxLife * 0.6) ? 0.8 : (life / (maxLife * 0.4));
        
    final alpha = (flashFactor * 0.6).clamp(0.0, 1.0);
    
    if (alpha > 0) {
      paint.color = Colors.white.withValues(alpha: alpha);
      paint.style = PaintingStyle.fill;
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    }
  }
}

class SnowParticle extends Particle {
  double x;
  double y;
  double speedY;
  double speedX;
  double radius;

  SnowParticle({
    required this.x,
    required this.y,
    required this.speedY,
    required this.speedX,
    required this.radius,
  });

  @override
  void update(double time) {
    y += speedY;
    // Enhanced fluttering effect
    x += speedX + sin(time * 2 + y * 0.05) * (radius * 0.5); 
  }

  @override
  bool isDead(Size size) => y > size.height || x < -50 || x > size.width + 50;

  @override
  void draw(Canvas canvas, Paint paint) {
    // Opacity based on radius (closer snowflakes are bigger and more opaque)
    final alpha = (radius / 6).clamp(0.4, 0.9);
    paint.color = Colors.white.withValues(alpha: alpha);
    paint.style = PaintingStyle.fill;
    
    // Glowing effect
    paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawCircle(Offset(x, y), radius, paint);
    paint.maskFilter = null;
    
    // Core of snowflake
    paint.color = Colors.white.withValues(alpha: alpha * 1.2);
    canvas.drawCircle(Offset(x, y), radius * 0.5, paint);
  }
}

class CloudParticle extends Particle {
  double x;
  double y;
  double speedX;
  double scale;

  CloudParticle({
    required this.x,
    required this.y,
    required this.speedX,
    required this.scale,
  });

  @override
  void update(double time) {
    x += speedX;
  }

  @override
  bool isDead(Size size) => x < -200 * scale;

  @override
  void draw(Canvas canvas, Paint paint) {
    paint.color = Colors.white.withValues(alpha: 0.15);
    paint.style = PaintingStyle.fill;
    
    canvas.save();
    canvas.translate(x, y);
    canvas.scale(scale);
    
    // Draw a smooth, premium cloud using Path (Bezier curves)
    final path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, -20, 20, -20);
    path.quadraticBezierTo(30, -40, 50, -35);
    path.quadraticBezierTo(70, -45, 85, -25);
    path.quadraticBezierTo(105, -20, 105, 0);
    path.close();
    
    // Add subtle shadow/blur for premium look
    paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawPath(path, paint);
    
    // Core of the cloud slightly more opaque
    paint.maskFilter = null;
    paint.color = Colors.white.withValues(alpha: 0.25);
    canvas.drawPath(path, paint);
    
    canvas.restore();
  }
}

class SunDustParticle extends Particle {
  double x;
  double y;
  double radius;
  double initialY;

  SunDustParticle({
    required this.x,
    required this.y,
    required this.radius,
  }) : initialY = y;

  @override
  void update(double time) {
    y -= 0.3; // Slower float up
    x += sin(time * 0.5 + initialY) * 0.8; // Broader sway
  }

  @override
  bool isDead(Size size) => y < -20;

  @override
  void draw(Canvas canvas, Paint paint) {
    // Shimmering effect
    final shimmer = 0.4 + sin(x * 0.05 + y * 0.05) * 0.3;
    paint.color = Colors.amber.withValues(alpha: shimmer);
    paint.style = PaintingStyle.fill;
    
    // Large blur for glowing dust
    paint.maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 1.5);
    canvas.drawCircle(Offset(x, y), radius, paint);
    
    // Bright core
    paint.maskFilter = null;
    paint.color = Colors.white.withValues(alpha: shimmer * 0.8);
    canvas.drawCircle(Offset(x, y), radius * 0.3, paint);
  }
}

class LeafParticle extends Particle {
  double x;
  double y;
  double speedX;
  double speedY;
  double rotation = 0;

  LeafParticle({
    required this.x,
    required this.y,
    required this.speedX,
    required this.speedY,
  });

  @override
  void update(double time) {
    x += speedX;
    y += speedY + sin(time * 5) * 2;
    rotation += 0.1;
  }

  @override
  bool isDead(Size size) => x < -50 || y > size.height + 50 || y < -50;

  @override
  void draw(Canvas canvas, Paint paint) {
    paint.color = Colors.green.withValues(alpha: 0.6);
    paint.style = PaintingStyle.fill;
    
    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(rotation);
    
    // Draw simple leaf shape
    final path = Path();
    path.moveTo(0, -10);
    path.quadraticBezierTo(10, -5, 15, 10);
    path.quadraticBezierTo(0, 5, -10, -5);
    path.close();
    
    canvas.drawPath(path, paint);
    canvas.restore();
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
