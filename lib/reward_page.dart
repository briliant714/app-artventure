import 'package:flutter/material.dart';
import 'music_background.dart';

class RewardPage extends StatefulWidget {
  const RewardPage({Key? key}) : super(key: key);

  @override
  State<RewardPage> createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  // Voucher progress (percentage)
  double voucherProgress = 0.0; // Initial progress (0%)
  bool canClaimVoucher = false;
  bool voucherClaimed = false;
  
  // Challenge data
  final List<Map<String, dynamic>> challengesList = [
    {
      'title': 'Quiz Master',
      'description': 'Menyelesaikan 5 kuis dengan skor minimal 75%',
      'progress': 0.25,
      'completed': true,
      'icon': Icons.psychology,
    },
    {
      'title': 'Video Learner',
      'description': 'Menonton 5 video pembelajaran sampai selesai',
      'progress': 0.25,
      'completed': true,
      'icon': Icons.play_circle_filled,
    },
    {
      'title': 'Perfect Score',
      'description': 'Mendapatkan nilai 100% dalam satu kuis',
      'progress': 0.25,
      'completed': false,
      'icon': Icons.star,
    },
    {
      'title': 'Fast Learner',
      'description': 'Menyelesaikan kuis dalam waktu kurang dari 2 menit',
      'progress': 0.25,
      'completed': false,
      'icon': Icons.speed,
    },
  ];
  
  @override
  void initState() {
    super.initState();
    
    // Hitung progress berdasarkan tantangan yang sudah selesai
    _calculateInitialProgress();
  }
  
  // Menghitung progress awal berdasarkan tantangan yang sudah selesai
  void _calculateInitialProgress() {
    double progress = 0.0;
    
    // Loop melalui semua tantangan
    for (final challenge in challengesList) {
      // Tambahkan 25% untuk setiap tantangan yang sudah selesai
      if (challenge['completed'] == true) {
        progress += 0.25;
      }
    }
    
    // Update state
    setState(() {
      voucherProgress = progress;
      // Aktifkan tombol klaim jika progress 100%
      if (progress >= 1.0) {
        canClaimVoucher = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get device size for responsive layout
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: MusicBackground(
        child: SafeArea(
          child: Column(
            children: [
              // App Bar with back button only
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              
              // Main content in Expanded
              Expanded(
                child: Column(
                  children: [
                    // Voucher container
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Voucher pembelian alat musik',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Rp. 100.000',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(height: 10),
                          
                          // Voucher progress bar
                          Stack(
                            children: [
                              // Background
                              Container(
                                width: double.infinity,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              
                              // Progress
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: (size.width - 96) * voucherProgress,
                                height: 20,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFF47B20), Color(0xFFEF8B60)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              
                              // Percentage text
                              Center(
                                child: SizedBox(
                                  height: 20,
                                  child: Center(
                                    child: Text(
                                      '${(voucherProgress * 100).toInt()}%',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Voucher claim button
                          SizedBox(
                            width: double.infinity,
                            height: 44,
                            child: ElevatedButton(
                              onPressed: canClaimVoucher && !voucherClaimed
                                  ? () => _showVoucherDialog(context)
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEF8B60),
                                disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 0),
                              ),
                              child: Text(
                                voucherClaimed
                                    ? 'Voucher Telah Diklaim'
                                    : canClaimVoucher
                                        ? 'Klaim Voucher'
                                        : 'Selesaikan Tantangan untuk Klaim',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Tantangan header
                    Padding(
                      padding: const EdgeInsets.only(left: 32, top: 16, bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            'Tantangan',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(1, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Challenges list
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        itemCount: challengesList.length,
                        itemBuilder: (context, index) {
                          final challenge = challengesList[index];
                          return _buildChallengeCard(
                            title: challenge['title'] as String,
                            description: challenge['description'] as String,
                            progress: challenge['progress'] as double,
                            completed: challenge['completed'] as bool,
                            icon: challenge['icon'] as IconData,
                            index: index,
                          );
                        },
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

  Widget _buildChallengeCard({
    required String title,
    required String description,
    required double progress,
    required bool completed,
    required IconData icon,
    required int index,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: completed ? Colors.greenAccent.withOpacity(0.7) : Colors.white.withOpacity(0.2),
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: completed ? Colors.green.withOpacity(0.3) : Colors.purple.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: completed ? Colors.greenAccent : Colors.white,
                size: 20,
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Title and description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Status and button
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Status text
                completed
                    ? const Text(
                        'Selesai',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent,
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.amberAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${(progress * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      
                const SizedBox(height: 4),
                
                // Button
                SizedBox(
                  height: 28,
                  child: ElevatedButton(
                    onPressed: completed ? null : () {
                      _claimChallenge(index);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: completed ? Colors.grey : const Color(0xFFEF8B60),
                      disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    ),
                    child: Text(
                      completed ? 'Diklaim' : 'Klaim',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: completed ? Colors.white.withOpacity(0.6) : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _claimChallenge(int index) {
    // Update the state
    setState(() {
      // Jika tantangan belum selesai
      if (!challengesList[index]['completed']) {
        challengesList[index]['completed'] = true;
        
        // Add progress to voucher - exactly 25% per challenge
        voucherProgress += 0.25; // Menggunakan nilai tetap 0.25 (25%)
        
        // Pastikan nilai tidak melebihi 1.0 (100%)
        if (voucherProgress > 1.0) {
          voucherProgress = 1.0;
        }
        
        // Aktifkan tombol klaim jika sudah 100%
        if (voucherProgress >= 1.0) {
          canClaimVoucher = true;
        }
      }
    });
    
    // Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Tantangan berhasil diklaim!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showVoucherDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        title: const Text(
          'Klaim Voucher',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16, // Font lebih kecil
          ),
          textAlign: TextAlign.center,
        ),
        contentPadding: const EdgeInsets.fromLTRB(14, 14, 14, 8), // Padding lebih kecil
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Voucher image - ukuran dikecilkan
            Container(
              width: 180, // Lebar dikurangi
              height: 100, // Tinggi dikurangi
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9C27B0), Color(0xFF673AB7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Decorative elements
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Icon(
                      Icons.music_note,
                      color: Colors.white.withOpacity(0.7),
                      size: 18, // Ukuran ikon lebih kecil
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Icon(
                      Icons.music_note,
                      color: Colors.white.withOpacity(0.7),
                      size: 18, // Ukuran ikon lebih kecil
                    ),
                  ),
                  
                  // Content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), // Padding lebih kecil
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'VOUCHER PEMBELIAN ALAT MUSIK',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 9, // Font lebih kecil
                            ),
                          ),
                        ),
                        const SizedBox(height: 6), // Spacing lebih kecil
                        const Text(
                          'Rp. 100.000',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18, // Font lebih kecil
                          ),
                        ),
                        const SizedBox(height: 3), // Spacing lebih kecil
                        Text(
                          'Kode: MUSIK2025',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 10, // Font lebih kecil
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 10), // Spacing lebih kecil
            const Text(
              'Selamat! Anda mendapatkan voucher pembelian alat musik senilai Rp. 100.000',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12, // Font lebih kecil
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5), // Spacing lebih kecil
            Text(
              'Kode voucher dapat digunakan di semua toko musik rekanan.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 10, // Font lebih kecil
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(4, 0, 4, 4), // Padding lebih kecil
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Padding lebih kecil
              minimumSize: Size.zero, // Menghilangkan ukuran minimum
              tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Mengurangi area tap
            ),
            child: const Text(
              'NANTI',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 11, // Font lebih kecil
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              
              setState(() {
                voucherClaimed = true;
              });
              
              // Show success snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Voucher berhasil diklaim!'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF8B60),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), // Padding lebih kecil
              minimumSize: Size.zero, // Menghilangkan ukuran minimum
              tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Mengurangi area tap
            ),
            child: const Text(
              'KLAIM',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11, // Font lebih kecil
              ),
            ),
          ),
        ],
      ),
    );
  }
}