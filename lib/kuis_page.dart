import 'package:flutter/material.dart';
import 'music_background.dart';

class KuisPage extends StatefulWidget {
  const KuisPage({Key? key}) : super(key: key);

  @override
  State<KuisPage> createState() => _KuisPageState();
}

class _KuisPageState extends State<KuisPage> {
  int _currentQuestion = 0;
  int _totalQuestions = 5;
  String? _selectedAnswer;
  bool _isAnswered = false;
  bool _isCorrect = false;
  
  // Data pertanyaan kuis untuk semua level
  final List<Map<String, dynamic>> _questions = [
    {
      'level': 'LEVEL 1',
      'image': 'lib/assets/images/angklung.jpg',
      'question': '1. Apa nama alat musik ini?',
      'options': ['Angklung', 'Sasando', 'Rebana'],
      'correctAnswer': 'Angklung',
    },
    {
      'level': 'LEVEL 2',
      'image': 'lib/assets/images/violin.png',
      'question': '2. Apa nama alat musik ini?',
      'options': ['Biola', 'Gitar', 'Piano'],
      'correctAnswer': 'Biola',
    },
    {
      'level': 'LEVEL 3',
      'image': 'lib/assets/images/guitar.png',
      'question': '3. Apa nama alat musik ini?',
      'options': ['Seruling', 'Piano', 'Gitar'],
      'correctAnswer': 'Gitar',
    },
    {
      'level': 'LEVEL 4',
      'image': 'lib/assets/images/trumpet.jpg',
      'question': '4. Apa nama alat musik ini?',
      'options': ['Tuba', 'Terompet', 'Saxophone'],
      'correctAnswer': 'Terompet',
    },
    {
      'level': 'LEVEL 5',
      'image': 'lib/assets/images/drum.jpg',
      'question': '5. Apa nama alat musik ini?',
      'options': ['Drum', 'Tambur', 'Timpani'],
      'correctAnswer': 'Drum',
    },
  ];
  
  void _checkAnswer() {
    setState(() {
      _isAnswered = true;
      _isCorrect = _selectedAnswer == _questions[_currentQuestion]['correctAnswer'];
    });
    
    // Delay sebelum menampilkan halaman hasil
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(
              isCorrect: _isCorrect,
              onNext: _goToNextQuestion,
            ),
          ),
        ).then((_) {
          // Reset state setelah kembali dari halaman hasil
          if (mounted) {
            setState(() {
              _selectedAnswer = null;
              _isAnswered = false;
            });
          }
        });
      }
    });
  }
  
  void _goToNextQuestion() {
    if (_currentQuestion < _totalQuestions - 1) {
      setState(() {
        _currentQuestion++;
        _selectedAnswer = null;
        _isAnswered = false;
      });
    } else {
      // Kuis selesai, kembali ke halaman utama
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final currentQuestionData = _questions[_currentQuestion];
    
    return Scaffold(
      body: MusicBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with close button and progress indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Close button with music note
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
                    
                    // Progress indicator
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Colors.white70,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${_currentQuestion + 1} / 3',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Level title
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    currentQuestionData['level'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFEF8B60),
                    ),
                  ),
                ),
              ),
              
              // Main content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question text
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          currentQuestionData['question'],
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      
                      // Image and options side by side
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image
                            Container(
                              width: 140,
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.blue.shade400, width: 1),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.asset(
                                currentQuestionData['image'],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  print('Error loading image: $error');
                                  return Container(
                                    color: Colors.grey.shade800,
                                    child: const Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        color: Colors.white54,
                                        size: 40,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            
                            // Spacing
                            const SizedBox(width: 16),
                            
                            // Options column
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Answer options
                                  ...(currentQuestionData['options'] as List<String>).map<Widget>((option) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: _buildAnswerOption(option),
                                    );
                                  }).toList(),
                                  
                                  const SizedBox(height: 12),
                                  
                                  // Next button
                                  _buildNextButton(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Music decoration
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
                  child: Icon(
                    Icons.music_note,
                    color: Colors.white.withOpacity(0.7),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildAnswerOption(String option) {
    final isSelected = _selectedAnswer == option;
    
    return GestureDetector(
      onTap: () {
        if (!_isAnswered) {
          setState(() {
            _selectedAnswer = option;
          });
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected 
              ? Colors.deepPurple.shade700 
              : Colors.deepPurple.shade900.withOpacity(0.7),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected 
                ? Colors.purpleAccent.shade100 
                : Colors.deepPurple.shade700,
            width: 1,
          ),
        ),
        child: Text(
          option,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
  
  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      height: 36,
      child: ElevatedButton(
        onPressed: _selectedAnswer != null ? _checkAnswer : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEF8B60),
          disabledBackgroundColor: const Color(0xFFEF8B60).withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          'Selanjutnya',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Widget untuk halaman hasil (benar/salah)
class ResultPage extends StatelessWidget {
  final bool isCorrect;
  final VoidCallback onNext;
  
  const ResultPage({Key? key, required this.isCorrect, required this.onNext}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MusicBackground(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Status bar
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      // Time removed as requested
                    ],
                  ),
                ),
                
                // Spacer yang lebih kecil di atas
                const Spacer(flex: 2),
                
                // Image/mascot (fox character) - ukuran lebih besar
                Image.asset(
                  isCorrect 
                      ? 'lib/assets/images/fox_happy.png' 
                      : 'lib/assets/images/fox_sad.png',
                  width: 220,
                  height: 220,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading fox image: $error');
                    return Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        color: isCorrect ? Colors.green : Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isCorrect ? Icons.sentiment_very_satisfied : Icons.sentiment_very_dissatisfied,
                        color: Colors.white,
                        size: 120,
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Result - gambar untuk pesan benar/salah
                Image.asset(
                  isCorrect 
                      ? 'lib/assets/images/correct_text.png' 
                      : 'lib/assets/images/wrong_text.png',
                  width: 300,
                  height: 80,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading result image: $error');
                    // Fallback ke teks jika gambar tidak tersedia
                    return Text(
                      isCorrect ? 'You did it!' : 'You\'re Wrong!',
                      style: TextStyle(
                        color: isCorrect ? Colors.blue : Colors.red.shade800,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black45,
                            offset: const Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                
                // Spacer yang lebih besar di bawah
                const Spacer(flex: 3),
                
                // Auto navigate to next level after delay
                FutureBuilder(
                  future: Future.delayed(const Duration(seconds: 3)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pop(context);
                        onNext();
                      });
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}