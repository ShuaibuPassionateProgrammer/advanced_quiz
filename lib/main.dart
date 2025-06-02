import 'package:flutter/material.dart';

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
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 18),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => QuizPage()),
      );
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.code, size: 80, color: Colors.indigo),
            SizedBox(height: 20),
            Text(
              'Programming Quiz',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Let’s test your fundamentals!',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
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
  bool _showingAnswer = false;
  int? _selectedIndex;

  void _handleAnswer(int index) {
    if (_showingAnswer) return;

    setState(() {
      _selectedIndex = index;
      _showingAnswer = true;
      if (index == _questions[_currentIndex]['correct']) {
        _score++;
      }
    });

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _currentIndex++;
        _showingAnswer = false;
        _selectedIndex = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= _questions.length) {
      return ResultScreen(score: _score, total: _questions.length);
    }

    final question = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentIndex + 1}/${_questions.length}'),
        centerTitle: true,
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
                    side: BorderSide(color: Colors.indigo.shade100),
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

  @override
  Widget build(BuildContext context) {
    String message;
    double percent = score / total;

    if (percent >= 0.9) {
      message = 'Excellent!';
    } else if (percent >= 0.7) {
      message = 'Great job!';
    } else if (percent >= 0.5) {
      message = 'Good effort!';
    } else {
      message = 'Keep practicing!';
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.emoji_events, size: 100, color: Colors.amber),
              SizedBox(height: 20),
              Text(
                message,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                'Your score: $score / $total',
                style: TextStyle(fontSize: 20),
              ),
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
  }
}
