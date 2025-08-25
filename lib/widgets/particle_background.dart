import 'package:flutter/material.dart';
import 'dart:math';

class Particle {
  Offset position;
  Color color;
  double speed;
  double size;

  Particle({
    required this.position,
    required this.color,
    required this.speed,
    required this.size,
  });
}

class ParticleBackground extends StatefulWidget {
  final int numberOfParticles;

  const ParticleBackground({super.key, this.numberOfParticles = 50});

  @override
  ParticleBackgroundState createState() => ParticleBackgroundState();
}

class ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  List<Particle> particles = [];
  late AnimationController _controller;
  bool _particlesInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_particlesInitialized) {
      _initializeParticles();
      _particlesInitialized = true;
    }
  }

  void _initializeParticles() {
    final random = Random();
    final size = MediaQuery.of(context).size;
    for (int i = 0; i < widget.numberOfParticles; i++) {
      particles.add(
        Particle(
          position: Offset(
            random.nextDouble() * size.width,
            random.nextDouble() * size.height,
          ),
          color: Color.fromRGBO(
            255,
            215,
            random.nextInt(100) + 100,
            random.nextDouble() * 0.8 + 0.2,
          ),
          speed: random.nextDouble() * 20 + 10,
          size: random.nextDouble() * 4 + 1,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(particles, _controller.value),
          child: Container(),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter(this.particles, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()..color = particle.color;
      final newY = (particle.position.dy + particle.speed * animationValue) % size.height;
      canvas.drawCircle(
        Offset(particle.position.dx, newY),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

