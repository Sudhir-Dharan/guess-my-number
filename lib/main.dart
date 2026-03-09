import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const GuessMyNumberApp());
}

class GuessMyNumberApp extends StatelessWidget {
  const GuessMyNumberApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guess My Number',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF22C55E)),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const GuessMyNumberPage(),
    );
  }
}

class GuessMyNumberPage extends StatefulWidget {
  const GuessMyNumberPage({super.key});

  @override
  State<GuessMyNumberPage> createState() => _GuessMyNumberPageState();
}

class _GuessMyNumberPageState extends State<GuessMyNumberPage> {
  static const int min = 1;
  static const int max = 100;

  final TextEditingController _secretController = TextEditingController();
  final TextEditingController _guessController = TextEditingController();

  int? _secret;
  int _round = 0;
  int _computerMin = min;
  int _computerMax = max;
  bool _gameOver = false;
  String _status = 'Set a secret number to start.';

  final List<RoundResult> _history = [];

  void _startGame() {
    final value = int.tryParse(_secretController.text.trim());
    if (value == null || value < min || value > max) {
      _setStatus('Enter a secret number between $min and $max.', Colors.amber);
      return;
    }

    setState(() {
      _secret = value;
      _round = 0;
      _computerMin = min;
      _computerMax = max;
      _history.clear();
      _gameOver = false;
      _guessController.clear();
      _status = 'Game on. You and the computer will guess each round.';
    });
  }

  void _reset() {
    setState(() {
      _secret = null;
      _round = 0;
      _computerMin = min;
      _computerMax = max;
      _history.clear();
      _gameOver = false;
      _secretController.clear();
      _guessController.clear();
      _status = 'Set a secret number to start.';
    });
  }

  void _setStatus(String text, Color color) {
    setState(() {
      _status = text;
    });
  }

  void _playRound() {
    if (_secret == null || _gameOver) return;

    final userGuess = int.tryParse(_guessController.text.trim());
    if (userGuess == null || userGuess < min || userGuess > max) {
      _setStatus('Enter your guess between $min and $max.', Colors.amber);
      return;
    }

    final compGuess = (_computerMin + _computerMax) ~/ 2;

    final userHint = _hintFor(userGuess, _secret!);
    final compHint = _hintFor(compGuess, _secret!);

    setState(() {
      _round += 1;
      _history.add(RoundResult(
        round: _round,
        userGuess: userGuess,
        userHint: userHint,
        computerGuess: compGuess,
        computerHint: compHint,
      ));

      if (compHint == Hint.higher) {
        _computerMin = compGuess + 1;
      } else if (compHint == Hint.lower) {
        _computerMax = compGuess - 1;
      }

      if (userHint == Hint.correct && compHint == Hint.correct) {
        _status = 'It is a tie. Both guessed correctly!';
        _gameOver = true;
      } else if (userHint == Hint.correct) {
        _status = 'You win. You guessed it first.';
        _gameOver = true;
      } else if (compHint == Hint.correct) {
        _status = 'Computer wins. It guessed your number.';
        _gameOver = true;
      } else {
        _status = 'Next round. Keep going.';
      }
    });
  }

  Hint _hintFor(int guess, int secret) {
    if (guess == secret) return Hint.correct;
    if (guess < secret) return Hint.higher;
    return Hint.lower;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Color(0xFF1F2937), Color(0xFF0F172A)],
            radius: 1.2,
            center: Alignment.topLeft,
          ),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Card(
            color: const Color(0xFF111827),
            elevation: 12,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Guess My Number: Human vs Computer',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'You choose a secret number. You and the computer take turns guessing. First correct guess wins.',
                    style: TextStyle(color: Color(0xFF9CA3AF)),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _StatChip(label: 'Round', value: _round.toString()),
                      _StatChip(label: 'Computer range', value: '$_computerMin - $_computerMax'),
                      _StatChip(label: 'Secret', value: _secret == null ? 'Not set' : 'Locked'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (_secret == null) ...[
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        SizedBox(
                          width: 220,
                          child: TextField(
                            controller: _secretController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Set secret (1-100)',
                              filled: true,
                              fillColor: const Color(0xFF0B1020),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFF1F2937)),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _startGame,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            backgroundColor: const Color(0xFF22C55E),
                            foregroundColor: const Color(0xFF052E16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Start Game'),
                        ),
                      ],
                    ),
                  ] else ...[
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        SizedBox(
                          width: 220,
                          child: TextField(
                            controller: _guessController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Your guess (1-100)',
                              filled: true,
                              fillColor: const Color(0xFF0B1020),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xFF1F2937)),
                              ),
                            ),
                            onSubmitted: (_) => _playRound(),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _playRound,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            backgroundColor: const Color(0xFF22C55E),
                            foregroundColor: const Color(0xFF052E16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Play Round'),
                        ),
                        OutlinedButton(
                          onPressed: _reset,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            foregroundColor: const Color(0xFFE5E7EB),
                            side: const BorderSide(color: Color(0xFF1F2937)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Reset'),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  Text(_status, style: const TextStyle(fontSize: 16, color: Color(0xFFE5E7EB))),
                  const SizedBox(height: 16),
                  const Text('History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B1020),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF1F2937)),
                    ),
                    child: _history.isEmpty
                        ? const Text('No rounds yet.', style: TextStyle(color: Color(0xFF9CA3AF)))
                        : Column(
                            children: _history.map((r) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 70, child: Text('Round ${r.round}')),
                                    Expanded(
                                      child: Wrap(
                                        spacing: 16,
                                        runSpacing: 6,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text('You: '),
                                              Text('${r.userGuess}'),
                                              const SizedBox(width: 6),
                                              HintIcon(r.userHint),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text('Computer: '),
                                              Text('${r.computerGuess}'),
                                              const SizedBox(width: 6),
                                              HintIcon(r.computerHint),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum Hint { higher, lower, correct }

class RoundResult {
  final int round;
  final int userGuess;
  final Hint userHint;
  final int computerGuess;
  final Hint computerHint;

  RoundResult({
    required this.round,
    required this.userGuess,
    required this.userHint,
    required this.computerGuess,
    required this.computerHint,
  });
}

class HintIcon extends StatelessWidget {
  final Hint hint;

  const HintIcon(this.hint, {super.key});

  @override
  Widget build(BuildContext context) {
    switch (hint) {
      case Hint.higher:
        return const Icon(Icons.arrow_upward, color: Color(0xFFFCD34D), size: 18);
      case Hint.lower:
        return const Icon(Icons.arrow_downward, color: Color(0xFFFCD34D), size: 18);
      case Hint.correct:
        return const Icon(Icons.check_circle, color: Color(0xFF86EFAC), size: 18);
    }
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF151C2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1F2937)),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
          children: [
            TextSpan(text: '$label: '),
            TextSpan(
              text: value,
              style: const TextStyle(color: Color(0xFFE5E7EB), fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
