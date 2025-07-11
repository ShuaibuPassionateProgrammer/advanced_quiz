import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Programming Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Color(0xFFF5F7FA),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}

// Splash Screen
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => QuizPage()));
    });

    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flash_on, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text('Programming Quiz',
                style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Let’s test your knowledge!',
                style: TextStyle(color: Colors.white70, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

// Quiz Page
class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What does "int" represent in programming?',
      'answers': ['A decimal number', 'A character', 'An integer number', 'A string'],
      'correct': 2
    },
    {
      'question': 'Which keyword is used to define a function in Python?',
      'answers': ['func', 'function', 'def', 'define'],
      'correct': 2
    },
    {
      'question': 'Which of these is a loop structure?',
      'answers': ['if', 'while', 'case', 'break'],
      'correct': 1
    },
    {
      'question': 'What is the value of: 3 + 2 * 2?',
      'answers': ['10', '7', '12', '9'],
      'correct': 1
    },
    {
      'question': 'Which symbol is used for comments in C++?',
      'answers': ['#', '//', '/* */', '--'],
      'correct': 1
    },
    {
      'question': 'Which of the following is a data type?',
      'answers': ['int', 'loop', 'print', 'def'],
      'correct': 0
    },
    {
      'question': 'What does "return" do in a function?',
      'answers': ['Repeats the function', 'Ends the program', 'Sends back a value', 'Skips the next line'],
      'correct': 2
    },
    {
      'question': 'Which of these is used for decision making?',
      'answers': ['for', 'if', 'int', 'def'],
      'correct': 1
    },
    {
      'question': 'How do you start an array index in most languages?',
      'answers': ['1', '0', '-1', 'any'],
      'correct': 1
    },
    {
      'question': 'What is the result of 5 % 2?',
      'answers': ['2', '1', '0', '3'],
      'correct': 1
    },
  ];

  int _currentIndex = 0;
  int _score = 0;
  int? _selectedIndex;
  bool _showingAnswer = false;

  int _timeLeft = 10;
  double _progress = 1.0;
  late Timer _timer;

  int _highestScore = 0;

  @override
  void initState() {
    super.initState();
    _loadHighestScore();
    _startTimer();
  }

  void _startTimer() {
    _timeLeft = 10;
    _progress = 1.0;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft == 0) {
        _handleTimeout();
      } else {
        setState(() {
          _timeLeft--;
          _progress = _timeLeft / 10;
        });
      }
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  void _handleTimeout() {
    _stopTimer();
    setState(() {
      _showingAnswer = true;
      _selectedIndex = null;
    });
    Future.delayed(Duration(seconds: 1), _nextQuestion);
  }

  void _handleAnswer(int index) {
    if (_showingAnswer) return;

    _stopTimer();
    setState(() {
      _selectedIndex = index;
      _showingAnswer = true;
      if (index == _questions[_currentIndex]['correct']) {
        _score++;
      }
    });
    Future.delayed(Duration(seconds: 1), _nextQuestion);
  }

  void _nextQuestion() {
    if (_currentIndex + 1 >= _questions.length) {
      _saveScore();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ResultScreen(score: _score, total: _questions.length)),
      );
    } else {
      setState(() {
        _currentIndex++;
        _selectedIndex = null;
        _showingAnswer = false;
      });
      _startTimer();
    }
  }

  void _saveScore() async {
    final prefs = await SharedPreferences.getInstance();
    int? saved = prefs.getInt('highest_score');
    if (saved == null || _score > saved) {
      await prefs.setInt('highest_score', _score);
    }
  }

  void _loadHighestScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _highestScore = prefs.getInt('highest_score') ?? 0;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentIndex + 1}/${_questions.length}'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 34,
                  height: 34,
                  child: CircularProgressIndicator(
                    value: _progress,
                    strokeWidth: 4,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                Text(
                  '$_timeLeft',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                )
              ],
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _questions.length,
              backgroundColor: Colors.grey[300],
              color: Colors.indigo,
              minHeight: 6,
            ),
            SizedBox(height: 30),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  question['question'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: 30),
            ...List.generate(question['answers'].length, (index) {
              Color? buttonColor;
              if (_showingAnswer) {
                if (index == question['correct']) {
                  buttonColor = Colors.green;
                } else if (index == _selectedIndex) {
                  buttonColor = Colors.red;
                } else {
                  buttonColor = Colors.grey[300];
                }
              }

              return Container(
                margin: EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: () => _handleAnswer(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: buttonColor != null ? Colors.white : null,
                  ),
                  child: Text(question['answers'][index]),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// Result Screen
class ResultScreen extends StatelessWidget {
  final int score;
  final int total;

  ResultScreen({required this.score, required this.total});

  Future<int> _getHighestScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('highest_score') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _getHighestScore(),
      builder: (context, snapshot) {
        final highScore = snapshot.data ?? 0;
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emoji_events, size: 100, color: Colors.amber),
                  SizedBox(height: 20),
                  Text('Quiz Completed!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Text('Your Score: $score / $total', style: TextStyle(fontSize: 20)),
                  Text('Highest Score: $highScore', style: TextStyle(fontSize: 18, color: Colors.grey[700])),
                  SizedBox(height: 30),
                  ElevatedButton.icon(
                    icon: Icon(Icons.refresh),
                    label: Text('Restart Quiz'),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => QuizPage()),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
