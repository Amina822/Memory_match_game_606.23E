import 'dart:async';
import 'package:flutter/material.dart';
import '../models/card_model.dart';
import '../widgets/card_tile.dart';
import '../widgets/result_dialog.dart';
import '../services/local_storage_service.dart';

class GamePage extends StatefulWidget {
  final int gridSize;
  final String difficulty;

  const GamePage({
    super.key,
    required this.gridSize,
    required this.difficulty,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late List<CardModel> _cards;
  CardModel? _firstCard;
  CardModel? _secondCard;
  int _moves = 0;
  Timer? _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    _moves = 0;
    _seconds = 0;
    _firstCard = null;
    _secondCard = null;
    _initializeGame();
    _timer?.cancel();
    _startTimer();
  }

  void _initializeGame() {
    final List<String> imagePaths = List.generate(
      32,
      (index) => 'assets/images/image_${index + 1}.png',
    );

    int pairCount = (widget.gridSize * widget.gridSize) ~/ 2;

    List<String> selectedImages = imagePaths.take(pairCount).toList();
    List<String> gameImages = [...selectedImages, ...selectedImages]..shuffle();

    _cards = gameImages.map((path) => CardModel(imagePath: path)).toList();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        _seconds++;
      });
    });
  }

  Future<void> _onCardTap(int index) async {
    if (_cards[index].isFlipped || _cards[index].isMatched || _secondCard != null) return;

    setState(() {
      _cards[index].isFlipped = true;
    });

    if (_firstCard == null) {
      _firstCard = _cards[index];
    } else {
      _secondCard = _cards[index];
      _moves++;

      if (_firstCard!.imagePath == _secondCard!.imagePath) {
        _firstCard!.isMatched = true;
        _secondCard!.isMatched = true;
        _firstCard = null;
        _secondCard = null;

        if (_cards.every((card) => card.isMatched)) {
          _timer?.cancel();

          await LocalStorageService.saveGameResult(
            GameResult(
              difficulty: widget.difficulty.split(' ').first.toLowerCase(),
              time: _seconds,
              moves: _moves,
            ),
          );

          if (!mounted) return;

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => ResultDialog(
              moves: _moves,
              seconds: _seconds,
              onPlayAgain: () {
                Navigator.of(context).pop(); 
                if (!mounted) return;
                setState(() {
                  _startNewGame();
                });
              },
              onExit: () {
     if (!mounted) return;
      Navigator.of(context).pop(); 
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false); 
   },
            ),
          );
        }
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          if (!mounted) return;
          setState(() {
            _firstCard!.isFlipped = false;
            _secondCard!.isFlipped = false;
            _firstCard = null;
            _secondCard = null;
          });
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.difficulty} Mode'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Moves: $_moves', style: const TextStyle(fontSize: 16)),
                Text('Time: $_seconds s', style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.gridSize,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                final card = _cards[index];
                return CardTile(
                  card: card,
                  onTap: () => _onCardTap(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
