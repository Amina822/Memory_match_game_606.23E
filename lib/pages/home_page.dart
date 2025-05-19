import 'package:flutter/material.dart';
import '../pages/game_page.dart';
import '../pages/history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedDifficulty;
  int? selectedGridSize;

  final List<Map<String, dynamic>> difficulties = [
    {
      "label": "Easy 4x4",
      "color": Colors.green,
      "gridSize": 4,
    },
    {
      "label": "Medium 6x6",
      "color": Colors.orange,
      "gridSize": 6,
    },
    {
      "label": "Hard 8x8",
      "color": Colors.red,
      "gridSize": 8,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Select the difficulty",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              for (var difficulty in difficulties)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedDifficulty = difficulty["label"];
                        selectedGridSize = difficulty["gridSize"];
                      });
                    },
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: selectedDifficulty == difficulty["label"]
                            ? difficulty["color"]
                            : difficulty["color"].withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedDifficulty == difficulty["label"]
                              ? Colors.black
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        difficulty["label"],
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: selectedDifficulty != null
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GamePage(
                                    gridSize: selectedGridSize!,
                                    difficulty: selectedDifficulty!,
                                  ),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(250, 55),
                        elevation: 5,
                        backgroundColor: selectedDifficulty != null
                            ? const Color.fromARGB(255, 12, 194, 194)
                            : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Start Game",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HistoryPage()),
                       );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(200, 50),
                        backgroundColor: const Color.fromARGB(255, 165, 212, 235),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "View History",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
