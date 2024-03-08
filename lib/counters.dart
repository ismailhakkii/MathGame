import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;
  int _randomNumber = Random().nextInt(100) + 1;
  Timer? _timer;
  int _timeLeft = 100;
  int _score = 100;
  bool _gameOver = false;

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_gameOver) {
        _timer?.cancel();
      } else {
        if (_timeLeft <= 0) {
          _timer?.cancel();
          _gameOver = true;
          _calculateFinalScore();
          _showGameOverDialog(isTimeout: true);
        } else {
          setState(() {
            _timeLeft--;
          });
        }
      }
    });
  }

  void _calculateFinalScore() {
    setState(() {
      _score = (_score + _timeLeft) ~/ 2; 
    });
  }

  Widget _buildButton(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(text),
      onPressed: () {
        if (!_gameOver) {
          onPressed();
          setState(() {
            _score -= 5;
            _timeLeft = max(0, _timeLeft - 5);
          });
        }
      },
      style: ElevatedButton.styleFrom(
        primary: const Color.fromARGB(255, 237, 54, 4),
        onPrimary: Colors.white,
      ),
    );
  }

  void _resetGame() {
    setState(() {
      _counter = 0;
      _randomNumber = Random().nextInt(100) + 1;
      _score = 100;
      _timeLeft = 100;
      _gameOver = false;
    });
    _startTimer();
  }

  void _checkResult() {
    final bool isCorrect = _counter == _randomNumber;
    _gameOver = true;
    _calculateFinalScore();
    _timer?.cancel();
    _showGameOverDialog(isTimeout: false, isCorrect: isCorrect);
  }

  void _showGameOverDialog({bool isTimeout = false, bool isCorrect = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isTimeout ? 'Time\'s Up!' : isCorrect ? 'Congratulations!' : 'Try Again!'),
          content: Text(
              isTimeout ? 'You ran out of time. Final Score: 0!!' : 
              isCorrect ? 'You guessed the right number. \n Final Score: $_score!!': 
              'Wrong guess. Final Score:0'),
          actions: <Widget>[
            TextButton(
              child:const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                _resetGame();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Random Number: $_randomNumber', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            if (!_gameOver) ...[
              Text('Score: $_score', style: const TextStyle(fontSize: 22, color: Colors.green)),
              Text('Time Left: $_timeLeft', style: const TextStyle(fontSize: 22, color: Colors.red)),
              const SizedBox(height: 40),
              Text('$_counter', style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: <Widget>[
                  _buildButton('Add 1', Icons.add, () => _counter++),
                  _buildButton('Multiply by 2', Icons.clear, () => _counter *= 2),
                  _buildButton('Square', Icons.exposure, () => _counter = _counter * _counter),
                  _buildButton('Divide by 2', Icons.horizontal_split, () => _counter ~/= 2),
                  _buildButton('Subtract 1', Icons.remove, () => _counter--),
                  _buildButton('Add 50', Icons.exposure_plus_2, () => _counter += 50),
                  _buildButton('Substract -15', Icons.fifteen_mp, () => _counter -= 15),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _checkResult,
                child: const Text('Check'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                ),
              ),
            ] else ...[
              const Text('Game Over :(', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)),
              Text('Your Final Score: $_score', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
              const Text('Do You Want to Try Again?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _resetGame,
                child: const Text('Restart'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}