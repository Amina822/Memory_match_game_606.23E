import 'package:flutter/material.dart';
import '../widgets/result_dialog.dart';

class ResultDialog extends StatelessWidget {
  final int moves;
  final int seconds;
  final VoidCallback? onPlayAgain;
  final VoidCallback? onExit;

  const ResultDialog({
    super.key,
    required this.moves,
    required this.seconds,
    this.onPlayAgain,
    this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple,
                blurRadius: 30,
                spreadRadius: 5,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.emoji_events_rounded,
                size: 72,
                color: Colors.amber,
              ),
              const SizedBox(height: 16),
              const Text(
                'Congratulations! 🎉',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'You won in $moves moves and $seconds seconds!',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.replay, color: Colors.white),
                    label: const Text(
                      'Play Again',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onPlayAgain?.call();
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.exit_to_app, color: Colors.white),
                    label: const Text(
                      'Exit',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade700,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      onExit?.call();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
