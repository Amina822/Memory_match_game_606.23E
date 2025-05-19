import 'package:flutter/material.dart';
import '../models/card_model.dart';
import 'dart:math';

class CardTile extends StatefulWidget {
  final CardModel card;
  final VoidCallback onTap;

  const CardTile({super.key, required this.card, required this.onTap});

  @override
  State<CardTile> createState() => _CardTileState();
}

class _CardTileState extends State<CardTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    if (widget.card.isFlipped) {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant CardTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.card.isFlipped && !_controller.isCompleted) {
      _controller.forward();
    } else if (!widget.card.isFlipped && _controller.isCompleted) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.card.isFlipped && !widget.card.isMatched) {
          widget.onTap();
        }
      },
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final angle = _flipAnimation.value * pi;
          final isUnderHalf = angle <= pi / 2;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isUnderHalf
                ? _buildCardBack()
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(pi),
                    child: _buildCardFront(),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildCardFront() {
    return Container(
      decoration: BoxDecoration(
        color: widget.card.isMatched ? Colors.green[300] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          widget.card.imagePath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.help_outline,
        color: Colors.white,
        size: 32,
      ),
    );
  }
}
