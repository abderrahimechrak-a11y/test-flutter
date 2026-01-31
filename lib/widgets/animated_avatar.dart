import 'package:flutter/material.dart';

class AnimatedAvatar extends StatefulWidget {
  final bool loading; // si on est en mode chargement
  const AnimatedAvatar({super.key, this.loading = false});

  @override
  State<AnimatedAvatar> createState() => _AnimatedAvatarState();
}

class _AnimatedAvatarState extends State<AnimatedAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Avatar qui pulse légèrement
        ScaleTransition(
          scale: Tween(begin: 0.9, end: 1.1).animate(controller),
          child: const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue,
            child: Icon(Icons.person, size: 60, color: Colors.white),
          ),
        ),
        // Indicateur de chargement si loading = true
        if (widget.loading)
          const Positioned(
            child: SizedBox(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 4,
              ),
            ),
          ),
      ],
    );
  }
}
