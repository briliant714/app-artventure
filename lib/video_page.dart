import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'music_background.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({Key? key}) : super(key: key);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  bool _isNavigationView = true;
  int _selectedVideoIndex = 0;
  VideoPlayerController? _videoPlayerController;
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = const Duration(minutes: 3, seconds: 52);
  Timer? _positionTimer;
  
  // Daftar video tutorial musik tradisional
  final List<Map<String, dynamic>> _videos = [
    {
      'title': 'Dongeng Angklung',
      'description': 'Pelajari tentang gamelan musik tradisional Jawa.',
      'thumbnail': 'assets/images/traditional_music.jpg',
      'duration': '06:08',
      'source': 'assets/videos/traditional_music.mp4',
      'youtubeUrl': 'https://www.youtube.com/watch?v=vwxAvkuz7VQ',
    },
    {
      'title': 'Mengenal Alat Musik Modern',
      'description': 'Pengenalan berbagai musik modern.',
      'thumbnail': 'assets/images/angklung.jpg',
      'duration': '03:02',
      'source': 'assets/videos/angklung.mp4',
      'youtubeUrl': 'https://www.youtube.com/watch?v=NTVLVmDwJRw',
    },
    {
      'title': 'Dongeng Tiga Musisi',
      'description': 'Tiga Musisi.',
      'thumbnail': 'assets/images/rebab.jpg',
      'duration': '12:30',
      'source': 'assets/videos/rebab.mp4',
      'youtubeUrl': 'https://www.youtube.com/watch?v=jccj0Salzg4',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startMockPositionTimer();
  }
  
  void _startMockPositionTimer() {
    _positionTimer?.cancel();
    
    if (_isPlaying) {
      _positionTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
        if (mounted) {
          setState(() {
            if (_position < _duration) {
              _position = _position + const Duration(milliseconds: 200);
            } else {
              _position = _duration;
              _isPlaying = false;
              timer.cancel();
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _positionTimer?.cancel();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  // Inisialisasi Video Player lokal
  void _initializeVideoPlayer(int index) {
    final videoSource = _videos[index]['source'] as String;
    
    try {
      _videoPlayerController?.dispose();
      
      _videoPlayerController = VideoPlayerController.asset(videoSource);
      
      _videoPlayerController!.initialize().then((_) {
        setState(() {
          _duration = _videoPlayerController!.value.duration;
          _isPlaying = false;
        });
      }).catchError((error) {
        print("Error initializing video player: $error");
        _showVideoError();
      });
      
      _videoPlayerController!.addListener(() {
        if (mounted) {
          setState(() {
            _position = _videoPlayerController!.value.position;
            _isPlaying = _videoPlayerController!.value.isPlaying;
          });
        }
      });
    } catch (e) {
      print("Error creating video player: $e");
      _showVideoError();
    }
  }
  
  void _showVideoError() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan saat memuat video.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
  
  // Fungsi untuk membuka YouTube di aplikasi eksternal
  void _openInYouTube(int index) {
    final url = _videos[index]['youtubeUrl'] as String;
    _launchURL(url);
  }
  
  // Fungsi untuk membuka URL eksternal
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Could not launch $url: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak dapat membuka YouTube. Pastikan aplikasi YouTube terinstal.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _playVideo(int index) {
    setState(() {
      _selectedVideoIndex = index;
      _isNavigationView = false;
    });
    
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: const Text('Pilih Opsi Pemutaran'),
        content: const Text('Bagaimana Anda ingin memutar video ini?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _initializeVideoPlayer(index);
            },
            child: const Text('Putar Video Lokal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _openInYouTube(index);
            },
            child: const Text('Buka di YouTube'),
          ),
        ],
      ),
    );
  }
  
  void _togglePlayPause() {
    if (_videoPlayerController != null && _videoPlayerController!.value.isInitialized) {
      if (_isPlaying) {
        _videoPlayerController!.pause();
      } else {
        _videoPlayerController!.play();
      }
    } else {
      setState(() {
        _isPlaying = !_isPlaying;
        
        if (_isPlaying) {
          _startMockPositionTimer();
        } else {
          _positionTimer?.cancel();
        }
      });
    }
  }
  
  void _skipForward() {
    if (_videoPlayerController != null && _videoPlayerController!.value.isInitialized) {
      final newPosition = _position + const Duration(seconds: 10);
      final maxDuration = _videoPlayerController!.value.duration;
      _videoPlayerController!.seekTo(newPosition > maxDuration ? maxDuration : newPosition);
    } else {
      setState(() {
        final newPosition = _position + const Duration(seconds: 10);
        _position = newPosition > _duration ? _duration : newPosition;
      });
    }
  }
  
  void _skipBackward() {
    if (_videoPlayerController != null && _videoPlayerController!.value.isInitialized) {
      final newPosition = _position - const Duration(seconds: 10);
      _videoPlayerController!.seekTo(newPosition.isNegative ? Duration.zero : newPosition);
    } else {
      setState(() {
        final newPosition = _position - const Duration(seconds: 10);
        _position = newPosition.isNegative ? Duration.zero : newPosition;
      });
    }
  }
  
  void _seekToPosition(Duration position) {
    if (_videoPlayerController != null && _videoPlayerController!.value.isInitialized) {
      _videoPlayerController!.seekTo(position);
    } else {
      setState(() {
        _position = position;
      });
    }
  }
  
  void _backToNavigation() {
    _positionTimer?.cancel();
    
    if (_videoPlayerController != null) {
      _videoPlayerController!.pause();
    }
    
    setState(() {
      _isNavigationView = true;
      _position = Duration.zero;
      _isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isNavigationView ? _buildNavigationView() : _buildVideoPlayerView(),
    );
  }
  
  Widget _buildNavigationView() {
    return MusicBackground(
      child: SafeArea(
        child: Stack(
          children: [
            // Nota musik background
            Positioned(
              top: 40,
              right: 16,
              child: Icon(
                Icons.music_note,
                color: Colors.white.withOpacity(0.1),
                size: 60,
              ),
            ),
            Positioned(
              bottom: 80,
              left: 30,
              child: Icon(
                Icons.music_note,
                color: Colors.white.withOpacity(0.1),
                size: 40,
              ),
            ),
            Positioned(
              top: 200,
              left: 50,
              child: Icon(
                Icons.music_note,
                color: Colors.white.withOpacity(0.1),
                size: 50,
              ),
            ),
            Positioned(
              bottom: 120,
              right: 40,
              child: Icon(
                Icons.music_note,
                color: Colors.white.withOpacity(0.1),
                size: 45,
              ),
            ),
            
            // Close button
            Positioned(
              top: 16,
              left: 16,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.close, color: Colors.white, size: 28),
              ),
            ),
            
            // Page counter
            Positioned(
              top: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '3 / 3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            
            // Video grid
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: _buildVideoThumbnail(0)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildVideoThumbnail(1)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildVideoThumbnail(2)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildVideoThumbnail(int index) {
    final video = _videos[index];
    
    return GestureDetector(
      onTap: () => _playVideo(index),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Video thumbnail with play button
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Thumbnail background
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Image.asset(
                      video['thumbnail'] as String,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.black.withOpacity(0.25),
                          width: double.infinity,
                          height: double.infinity,
                          child: const Icon(
                            Icons.music_note,
                            size: 50,
                            color: Colors.white24,
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Play button
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            
            // Video info bar
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: const BoxDecoration(
                color: Color(0xFF8B5E34),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video['title'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${video['duration']}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildVideoPlayerView() {
    final video = _videos[_selectedVideoIndex];
    
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          // Video Player atau Placeholder
          Positioned.fill(
            child: GestureDetector(
              onTap: _togglePlayPause,
              child: _videoPlayerController != null && _videoPlayerController!.value.isInitialized
                ? VideoPlayer(_videoPlayerController!)
                : Container(
                    color: Colors.black,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Video placeholder
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              video['thumbnail'] as String,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.music_note,
                                  size: 120,
                                  color: Colors.white.withOpacity(0.3),
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () {
                                _openInYouTube(_selectedVideoIndex);
                              },
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Putar di YouTube'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        
                        // Play/Pause overlay
                        AnimatedOpacity(
                          opacity: _isPlaying ? 0.0 : 0.8,
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.5),
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            ),
          ),
          
          // Top Bar with Back Button
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(8, 32, 12, 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    // Back Button
                    Container(
                      margin: const EdgeInsets.only(left: 8.0),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () {
                          _backToNavigation();
                        },
                      ),
                    ),
                    Expanded(
                      child: Text(
                        video['title'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.fullscreen, 
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () {
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.landscapeLeft,
                          DeviceOrientation.landscapeRight,
                        ]);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Video Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildAdvancedVideoControls(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAdvancedVideoControls() {
    String formatDuration(Duration duration) {
      final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
      final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      return "$minutes:$seconds";
    }
    
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(0.8),
            Colors.transparent,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Video progress dan display waktu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                children: [
                  // Current position
                  Text(
                    formatDuration(_position),
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  
                  const SizedBox(width: 4),
                  
                  // Progress bar with Slider
                  Expanded(
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 4,
                        activeTrackColor: Colors.amber,
                        inactiveTrackColor: Colors.white.withOpacity(0.3),
                        thumbColor: Colors.amber,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                      ),
                      child: Slider(
                        value: _position.inMilliseconds.toDouble(),
                        min: 0,
                        max: _duration.inMilliseconds.toDouble(),
                        onChanged: (value) {
                          final newPosition = Duration(milliseconds: value.toInt());
                          _seekToPosition(newPosition);
                        },
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 4),
                  
                  // Total duration
                  Text(
                    formatDuration(_duration),
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Playback controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Skip backward 10 seconds
                InkWell(
                  onTap: _skipBackward,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.replay_10,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '10 dtk',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Play/Pause
                GestureDetector(
                  onTap: _togglePlayPause,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.amber,
                    ),
                    child: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                
                // Skip forward 10 seconds
                InkWell(
                  onTap: _skipForward,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.forward_10,
                          color: Colors.white,
                          size: 28,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '10 dtk',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}