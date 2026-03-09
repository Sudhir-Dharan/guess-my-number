import 'dart:math';
import 'dart:html' as html;
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
  static const int maxAttempts = 10;

  final TextEditingController _controller = TextEditingController();

  late int _secret;
  int _attemptsLeft = maxAttempts;
  int _bestScore = 0;
  String _message = 'Make your first guess.';
  String _hint = 'Tip: try narrowing the range.';
  Color _messageColor = const Color(0xFFE5E7EB);

  @override
  void initState() {
    super.initState();
    _bestScore = _loadBestScore();
    _newGame();
  }

  int _loadBestScore() {
    final value = html.window.localStorage['bestScore'];
    return int.tryParse(value ?? '') ?? 0;
  }

  void _saveBestScore(int score) {
    html.window.localStorage['bestScore'] = score.toString();
  }

  void _setMessage(String text, Color color) {
    setState(() {
      _message = text;
      _messageColor = color;
    });
  }

  void _newGame() {
    setState(() {
      _secret = Random().nextInt(max - min + 1) + min;
      _attemptsLeft = maxAttempts;
      _controller.clear();
      _message = 'Make your first guess.';
      _hint = 'Tip: try narrowing the range.';
      _messageColor = const Color(0xFFE5E7EB);
    });
  }

  void _checkGuess() {
    final guess = int.tryParse(_controller.text.trim());
    if (guess == null || guess < min || guess > max) {
      _setMessage('Enter a number between $min and $max.', const Color(0xFFFCD34D));
      return;
    }

    setState(() {
      _attemptsLeft -= 1;
    });

    if (guess == _secret) {
      _setMessage('Correct! You guessed the number.', const Color(0xFF86EFAC));
      setState(() {
        _hint = 'Nice. Hit New Game to play again.';
      });
      if (_attemptsLeft > _bestScore) {
        _bestScore = _attemptsLeft;
        _saveBestScore(_bestScore);
      }
      return;
    }

    if (_attemptsLeft <= 0) {
      _setMessage('Game over. The number was $_secret.', const Color(0xFFFCA5A5));
      setState(() {
        _hint = 'Try again with New Game.';
      });
      return;
    }

    if (guess < _secret) {
      _setMessage('Too low. Try higher.', const Color(0xFFFCD34D));
    } else {
      _setMessage('Too high. Try lower.', const Color(0xFFFCD34D));
    }
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
          constraints: const BoxConstraints(maxWidth: 760),
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
                    'Guess My Number',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Can you guess the secret number between 1 and 100?',
                    style: TextStyle(color: Color(0xFF9CA3AF)),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      _StatChip(label: 'Attempts left', value: _attemptsLeft.toString()),
                      _StatChip(label: 'Best score', value: _bestScore.toString()),
                      const _StatChip(label: 'Range', value: '1 - 100'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      SizedBox(
                        width: 220,
                        child: TextField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Enter your guess',
                            filled: true,
                            fillColor: const Color(0xFF0B1020),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF1F2937)),
                            ),
                          ),
                          onSubmitted: (_) => _checkGuess(),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _checkGuess,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          backgroundColor: const Color(0xFF22C55E),
                          foregroundColor: const Color(0xFF052E16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Check'),
                      ),
                      OutlinedButton(
                        onPressed: _newGame,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          foregroundColor: const Color(0xFFE5E7EB),
                          side: const BorderSide(color: Color(0xFF1F2937)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('New Game'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(_message, style: TextStyle(fontSize: 18, color: _messageColor)),
                  const SizedBox(height: 6),
                  Text(_hint, style: const TextStyle(color: Color(0xFF9CA3AF))),
                  const SizedBox(height: 8),
                  const Text('Flutter web single‑page game. Drop it anywhere after build.',
                      style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
