import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GameResult {
  final String difficulty;
  final int moves;
  final int time;

  GameResult({
    required this.difficulty,
    required this.moves,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {'difficulty': difficulty, 'moves': moves, 'time': time};
  }

  factory GameResult.fromMap(Map<String, dynamic> map) {
    return GameResult(
      difficulty: map['difficulty'],
      moves: map['moves'],
      time: map['time'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GameResult.fromJson(String source) =>
      GameResult.fromMap(json.decode(source));
}

class LocalStorageService {
  static const String _key = 'game_results';

  static Future<void> saveGameResult(GameResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final results = prefs.getStringList(_key) ?? [];

    results.add(result.toJson());
    await prefs.setStringList(_key, results);
  }

  static Future<List<GameResult>> getAllResults() async {
    final prefs = await SharedPreferences.getInstance();
    final results = prefs.getStringList(_key) ?? [];
    return results.map((e) => GameResult.fromJson(e)).toList();
  }

  static Future<List<GameResult>> getTopResultsByDifficulty(
    String difficulty, {
    int limit = 5,
  }) async {
    final normalized = difficulty.trim().toLowerCase();
    final allResults = await getAllResults();

    final filtered =
        allResults
            .where((r) => r.difficulty.trim().toLowerCase() == normalized)
            .toList();

    filtered.sort((a, b) {
      if (a.moves != b.moves) return a.moves.compareTo(b.moves);
      return a.time.compareTo(b.time);
    });

    return filtered.take(limit).toList();
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
