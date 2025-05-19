import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<GameResult>> _allResults;
  late Future<Map<String, List<GameResult>>> _topResults;

  final Map<String, String> difficultyLabels = {
    'easy': 'Easy',
    'medium': 'Medium',
    'hard': 'Hard',
  };

  final Map<String, IconData> difficultyIcons = {
    'easy': Icons.star_border,
    'medium': Icons.star_half,
    'hard': Icons.star,
  };

  final Map<String, Color> difficultyColors = {
    'easy': Colors.greenAccent.shade100,
    'medium': Colors.orangeAccent.shade100,
    'hard': Colors.redAccent.shade100,
  };

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  void _loadAllData() {
    setState(() {
      _allResults = LocalStorageService.getAllResults();
      _topResults = _loadTopResults();
    });
  }

  Future<Map<String, List<GameResult>>> _loadTopResults() async {
    final Map<String, List<GameResult>> results = {};
    final allResults = await _allResults;

    for (final diff in difficultyLabels.keys) {
      final filtered =
          allResults
              .where(
                (r) => r.difficulty.toLowerCase().contains(diff.toLowerCase()),
              )
              .toList();

      filtered.sort((a, b) {
        if (a.moves != b.moves) return a.moves.compareTo(b.moves);
        return a.time.compareTo(b.time);
      });

      results[diff] = filtered.take(5).toList();
    }

    return results;
  }

  Widget _buildCard({required GameResult game, required int index}) {
    final diffKey = game.difficulty.toLowerCase();
    final diffLabel = difficultyLabels[diffKey] ?? game.difficulty;
    final diffIcon = difficultyIcons[diffKey] ?? Icons.extension;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Text('$index'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(diffIcon, size: 20, color: Colors.blueGrey),
                      const SizedBox(width: 6),
                      Text(
                        diffLabel,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.directions_walk,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text('${game.moves} moves'),
                      const SizedBox(width: 12),
                      const Icon(Icons.timer, size: 18, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('${game.time}s'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopResultsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          '🏆 Top 5 Games per Difficulty',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        FutureBuilder<Map<String, List<GameResult>>>(
          future: _topResults,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final results = snapshot.data ?? {};

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    difficultyLabels.entries.map((entry) {
                      final diffKey = entry.key;
                      final diffName = entry.value;
                      final games = results[diffKey] ?? [];

                      return Container(
                        width: 320,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color:
                              difficultyColors[diffKey] ?? Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                '$diffName Mode',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (games.isEmpty)
                              const Text('No games played yet.')
                            else
                              ...games.asMap().entries.map(
                                (entry) => _buildCard(
                                  game: entry.value,
                                  index: entry.key + 1,
                                ),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentGamesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🕓 Recent Games',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<GameResult>>(
          future: _allResults,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final games = snapshot.data ?? [];
            if (games.isEmpty) {
              return const Text('No games played yet.');
            }

            return Column(
              children:
                  games.reversed
                      .toList()
                      .asMap()
                      .entries
                      .map(
                        (entry) =>
                            _buildCard(game: entry.value, index: entry.key + 1),
                      )
                      .toList(),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAllData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildTopResultsSection(),
            const SizedBox(height: 32),
            _buildRecentGamesSection(),
          ],
        ),
      ),
    );
  }
}
