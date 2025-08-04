import 'package:flutter/material.dart';

class MusicBackground extends StatelessWidget {
  final Widget child;
  
  const MusicBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        // Gunakan gradien sebagai background utama
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.deepPurple.shade500,
            Colors.deepPurple.shade900,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Overlay untuk memperbaiki kontras (opsional, bisa dihapus jika tidak diperlukan)
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.1),
          ),
          
          // Music note decorations
          Positioned(
            top: 100,
            right: 20,
            child: _buildMusicNote(20, Colors.white.withOpacity(0.7)),
          ),
          Positioned(
            top: 200,
            left: 50,
            child: _buildMusicNote(15, Colors.white.withOpacity(0.7)),
          ),
          Positioned(
            bottom: 150,
            right: 70,
            child: _buildMusicNote(25, Colors.white.withOpacity(0.7)),
          ),
          Positioned(
            bottom: 300,
            left: 30,
            child: _buildMusicNote(18, Colors.white.withOpacity(0.7)),
          ),
          
          // Main content
          child,
        ],
      ),
    );
  }
  
  Widget _buildMusicNote(double size, Color color) {
    return Icon(
      Icons.music_note,
      size: size,
      color: color,
    );
  }
}