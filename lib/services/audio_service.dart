import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  AudioSession? _session;

  AudioPlayer get player => _player;

  // 初始化音频服务
  Future<void> initialize() async {
    try {
      // 初始化音频会话
      _session = await AudioSession.instance;

      // 配置音频会话以支持后台播放
      await _session!.configure(AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.allowBluetooth |
                AVAudioSessionCategoryOptions.allowAirPlay,
        avAudioSessionMode: AVAudioSessionMode.defaultMode,
        avAudioSessionRouteSharingPolicy:
            AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.music,
          flags: AndroidAudioFlags.none,
          usage: AndroidAudioUsage.media,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: false,
      ));

      // 监听音频会话中断
      _session!.interruptionEventStream.listen((event) {
        if (event.begin) {
          switch (event.type) {
            case AudioInterruptionType.duck:
              // 降低音量但继续播放
              _player.setVolume(0.5);
              break;
            case AudioInterruptionType.pause:
            case AudioInterruptionType.unknown:
              // 暂停播放
              _player.pause();
              break;
          }
        } else {
          switch (event.type) {
            case AudioInterruptionType.duck:
              // 恢复正常音量
              _player.setVolume(1.0);
              break;
            case AudioInterruptionType.pause:
              // 可以选择恢复播放或保持暂停状态
              break;
            case AudioInterruptionType.unknown:
              break;
          }
        }
      });

      // 监听音频焦点变化
      _session!.becomingNoisyEventStream.listen((_) {
        // 当耳机拔出时暂停播放
        _player.pause();
      });
    } catch (e) {
      print('Error initializing audio service: $e');
    }
  }

  // 播放资源文件
  Future<void> playAsset(String assetPath,
      {String? title, String? artist}) async {
    try {
      await _player.setAsset('assets/$assetPath');

      // 设置媒体信息用于锁屏控制
      if (title != null || artist != null) {
        await _setMediaInfo(title: title, artist: artist);
      }

      await _player.play();
    } catch (e) {
      print('Error playing asset: $e');
    }
  }

  // 设置媒体信息
  Future<void> _setMediaInfo({String? title, String? artist}) async {
    try {
      // 这里可以设置媒体信息，但just_audio会自动处理大部分情况
      // 如果需要更详细的媒体控制，可以使用audio_service包
    } catch (e) {
      print('Error setting media info: $e');
    }
  }

  // 播放网络音频
  Future<void> playUrl(String url) async {
    try {
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      print('Error playing URL: $e');
    }
  }

  // 暂停播放
  Future<void> pause() async {
    await _player.pause();
  }

  // 停止播放
  Future<void> stop() async {
    await _player.stop();
  }

  // 跳转到指定位置
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  // 设置音量
  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
  }

  // 设置播放速度
  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
  }

  // 设置循环模式
  Future<void> setLoopMode(LoopMode loopMode) async {
    await _player.setLoopMode(loopMode);
  }

  // 释放资源
  Future<void> dispose() async {
    await _player.dispose();
  }

  // 获取播放状态流
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  // 获取播放位置流
  Stream<Duration> get positionStream => _player.positionStream;

  // 获取缓冲位置流
  Stream<Duration> get bufferedPositionStream => _player.bufferedPositionStream;

  // 获取音频时长流
  Stream<Duration?> get durationStream => _player.durationStream;

  // 获取当前播放状态
  bool get isPlaying => _player.playing;

  // 获取当前位置
  Duration get position => _player.position;

  // 获取音频时长
  Duration? get duration => _player.duration;
}
