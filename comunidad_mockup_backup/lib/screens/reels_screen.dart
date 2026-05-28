import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:google_fonts/google_fonts.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  final List<Map<String, String>> _reels = [
    {
      'id': '1',
      'videoUrl': 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      'title': 'ENERRMAX',
      'subtitle': 'FEST',
      'likes': '12.5K',
      'comments': '432',
    },
    {
      'id': '2',
      'videoUrl': 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      'title': 'Title',
      'subtitle': 'Title',
      'likes': '8.2K',
      'comments': '215',
    },
    {
      'id': '3',
      'videoUrl': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      'title': 'Title',
      'subtitle': 'Title',
      'likes': '5.1K',
      'comments': '98',
    },
  ];

  late List<VideoPlayerController?> _controllers;
  late List<ChewieController?> _chewieControllers;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _controllers = List.generate(_reels.length, (index) => null);
    _chewieControllers = List.generate(_reels.length, (index) => null);
    _preloadVideos(0);
  }

  void _preloadVideos(int currentIndex) {
    for (int i = currentIndex - 1; i <= currentIndex + 1; i++) {
      if (i >= 0 && i < _reels.length && _controllers[i] == null) {
        _initializeVideo(i);
      }
    }
  }

  void _initializeVideo(int index) {
    final controller = VideoPlayerController.networkUrl(Uri.parse(_reels[index]['videoUrl']!));
    _controllers[index] = controller;
    controller.initialize().then((_) {
      if (mounted) {
        setState(() {
          _chewieControllers[index] = ChewieController(
            videoPlayerController: controller,
            autoPlay: index == _currentPage,
            looping: true,
            aspectRatio: 9 / 16,
            showControls: false,
            allowFullScreen: false,
            autoInitialize: true,
          );
        });
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller?.dispose();
    }
    for (var chewie in _chewieControllers) {
      chewie?.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
          _preloadVideos(index);
          for (int i = 0; i < _chewieControllers.length; i++) {
            if (_chewieControllers[i] != null && i != index) {
              _chewieControllers[i]!.pause();
            } else if (_chewieControllers[i] != null && i == index) {
              _chewieControllers[i]!.play();
            }
          }
        },
        itemCount: _reels.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Positioned.fill(
                child: _chewieControllers[index] != null
                    ? Chewie(controller: _chewieControllers[index]!)
                    : Container(color: Colors.black),
              ),
              Positioned(
                bottom: 80,
                left: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _reels[index]['title']!,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(blurRadius: 10, color: Colors.black26),
                        ],
                      ),
                    ),
                    Text(
                      _reels[index]['subtitle']!,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        shadows: [Shadow(blurRadius: 10, color: Colors.black26)],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 80,
                right: 16,
                child: Column(
                  children: [
                    _buildActionButton(Icons.favorite_border, _reels[index]['likes']!),
                    const SizedBox(height: 20),
                    _buildActionButton(Icons.chat_bubble_outline, _reels[index]['comments']!),
                    const SizedBox(height: 20)
                  ],
                ),
              ),
              Positioned(
                top: 48,
                left: 16,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 20, color: Color(0xFF005DB9)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'ENERRMAX',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(blurRadius: 10, color: Colors.black26)],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF32836),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'FEST',
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String count) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 4),
        Text(
          count,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }
}