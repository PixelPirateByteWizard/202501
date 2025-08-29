import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../services/audio_service.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> with TickerProviderStateMixin {
  final AudioService _audioService = AudioService();
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  
  int _currentIndex = 0;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  final List<Map<String, String>> _musicList = [
    {
      'title': 'A Moment For My Mind',
      'path': 'Music/A Moment For My Mind.mp3',
      'artist': 'AI Generated',
    },
    {
      'title': 'Endless And Whispers',
      'path': 'Music/Endless And Whispers.mp3',
      'artist': 'AI Generated',
    },
    {
      'title': 'Extremely High Variability',
      'path': 'Music/Extremely High Variability.mp3',
      'artist': 'AI Generated',
    },
    {
      'title': 'Heart Of Her Affection',
      'path': 'Music/Heart Of Her Affection.mp3',
      'artist': 'AI Generated',
    },
    {
      'title': 'I Love My Story',
      'path': 'Music/I Love My Story.mp3',
      'artist': 'AI Generated',
    },
    {
      'title': 'The Chemical Signatures',
      'path': 'Music/The Chemical Signatures.mp3',
      'artist': 'AI Generated',
    },
  ];

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _initializePlayer();
  }

  void _initializePlayer() async {
    // 初始化音频服务
    await _audioService.initialize();
    
    // 监听播放状态
    _audioService.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
        });
        
        if (_isPlaying) {
          _rotationController.repeat();
          _pulseController.repeat(reverse: true);
        } else {
          _rotationController.stop();
          _pulseController.stop();
        }
      }
    });

    // 监听播放位置
    _audioService.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }
    });

    // 监听音频时长
    _audioService.durationStream.listen((duration) {
      if (mounted && duration != null) {
        setState(() {
          _duration = duration;
        });
      }
    });

    // 监听播放完成
    _audioService.playerStateStream.listen((state) {
      if (mounted && state.processingState == ProcessingState.completed) {
        _nextTrack();
      }
    });
  }

  @override
  void dispose() {
    _audioService.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A0B2E),
              Color(0xFF2D1B3D),
              Color(0xFF4A1A6B),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildMusicPlayer(),
                      _buildPlaylist(),
                      _buildAIDescription(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.music_note_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            '时空音律',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMusicPlayer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 专辑封面
        AnimatedBuilder(
          animation: _rotationController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationController.value * 2 * 3.14159,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF6B2C9E),
                      Color(0xFF4A1A6B),
                      Color(0xFF2D1B3D),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withValues(alpha: 0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.music_note_rounded,
                  color: Colors.white,
                  size: 80,
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: 15),
        
        // 歌曲信息
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            _musicList[_currentIndex]['title']!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        
        const SizedBox(height: 4),
        
        Text(
          _musicList[_currentIndex]['artist']!,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14,
          ),
        ),
        
        const SizedBox(height: 15),
        
        // 进度条
        _buildProgressBar(),
        
        const SizedBox(height: 15),
        
        // 控制按钮
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildControlButton(
              Icons.skip_previous_rounded,
              () => _previousTrack(),
            ),
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_pulseController.value * 0.1),
                  child: _buildPlayButton(),
                );
              },
            ),
            _buildControlButton(
              Icons.skip_next_rounded,
              () => _nextTrack(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
              thumbColor: Colors.white,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              trackHeight: 4,
            ),
            child: Slider(
              value: _duration.inMilliseconds > 0
                  ? _position.inMilliseconds / _duration.inMilliseconds
                  : 0.0,
              onChanged: (value) {
                final position = Duration(
                  milliseconds: (value * _duration.inMilliseconds).round(),
                );
                _audioService.seek(position);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(_position),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
              Text(
                _formatDuration(_duration),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 30),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildPlayButton() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6B2C9E), Color(0xFF4A1A6B)],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: Colors.white,
          size: 40,
        ),
        onPressed: () => _togglePlayPause(),
      ),
    );
  }

  Widget _buildPlaylist() {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              '播放列表',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 8),
              itemCount: _musicList.length,
              itemBuilder: (context, index) {
                final isCurrentTrack = index == _currentIndex;
                return ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isCurrentTrack 
                          ? Colors.purple 
                          : Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isCurrentTrack && _isPlaying 
                          ? Icons.pause_rounded 
                          : Icons.music_note_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  title: Text(
                    _musicList[index]['title']!,
                    style: TextStyle(
                      color: isCurrentTrack ? Colors.purple[200] : Colors.white,
                      fontWeight: isCurrentTrack ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => _playTrack(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIDescription() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 5, 20, 15),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        '🎵 本音乐使用自研AI算法生成\n为您带来独特的时空音律体验',
        style: TextStyle(
          color: Colors.white70,
          fontSize: 12,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _togglePlayPause() async {
    if (_isPlaying) {
      await _audioService.pause();
    } else {
      await _playCurrentTrack();
    }
  }

  void _playTrack(int index) {
    if (mounted) {
      setState(() {
        _currentIndex = index;
      });
      _playCurrentTrack();
    }
  }

  void _nextTrack() {
    if (mounted) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _musicList.length;
      });
      _playCurrentTrack();
    }
  }

  void _previousTrack() {
    if (mounted) {
      setState(() {
        _currentIndex = (_currentIndex - 1 + _musicList.length) % _musicList.length;
      });
      _playCurrentTrack();
    }
  }

  Future<void> _playCurrentTrack() async {
    try {
      final track = _musicList[_currentIndex];
      await _audioService.playAsset(
        track['path']!,
        title: track['title'],
        artist: track['artist'],
      );
    } catch (e) {
      print('Error playing audio: $e');
    }
  }
}