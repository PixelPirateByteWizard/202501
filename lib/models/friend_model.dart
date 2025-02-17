import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';

part 'friend_model.g.dart';

@JsonSerializable()
class InstrumentMessage {
  @JsonKey(required: true)
  final String type;

  @JsonKey(required: true)
  final String content;

  @JsonKey(required: true)
  final DateTime timestamp;

  const InstrumentMessage({
    required this.type,
    required this.content,
    required this.timestamp,
  });

  factory InstrumentMessage.fromJson(Map<String, dynamic> json) =>
      _$InstrumentMessageFromJson(json);
  Map<String, dynamic> toJson() => _$InstrumentMessageToJson(this);
}

@JsonSerializable()
class Friend {
  @JsonKey(required: true)
  final String id;

  @JsonKey(required: true)
  final String name;

  @JsonKey(required: true)
  final String avatarAsset;

  @JsonKey(defaultValue: '')
  final String bio;

  @JsonKey(defaultValue: <String>[])
  final List<String> mainInstrument;

  @JsonKey(required: true)
  final int musicExperience; // Music experience in years

  @JsonKey(defaultValue: <String>[])
  final List<String> favoriteGenres; // Favorite music genres

  @JsonKey(required: true)
  final String practiceFrequency; // Practice frequency

  @JsonKey(defaultValue: false)
  final bool isOnline;

  @JsonKey(required: true)
  final DateTime lastActive;

  @JsonKey(defaultValue: <String>[])
  final List<String> instrumentAssets;

  @JsonKey(defaultValue: <InstrumentMessage>[])
  final List<InstrumentMessage> instrumentMessages;

  @JsonKey(ignore: true)
  late final Color themeColor;

  Friend({
    required this.id,
    required this.name,
    required this.avatarAsset,
    required this.bio,
    required this.mainInstrument,
    required this.musicExperience,
    required this.favoriteGenres,
    required this.practiceFrequency,
    required this.isOnline,
    required this.lastActive,
    required this.instrumentAssets,
    required this.instrumentMessages,
    Color? themeColor,
  }) : themeColor = themeColor ?? const Color(0xFFE6B8AF);

  factory Friend.fromJson(Map<String, dynamic> json) {
    final friend = _$FriendFromJson(json);
    // Map colors based on id
    final colors = {
      '1': const Color(0xFFE6B8AF),
      '2': const Color(0xFFB6D7A8),
      '3': const Color(0xFFB4A7D6),
      '4': const Color(0xFFF9CB9C),
      '5': const Color(0xFFFFD5C2),
      '6': const Color(0xFFD5A6BD),
      '7': const Color(0xFFA2C4C9),
    };
    friend.themeColor = colors[friend.id] ?? const Color(0xFFE6B8AF);
    return friend;
  }

  Map<String, dynamic> toJson() => _$FriendToJson(this);
}

// Sample friend data
final List<Friend> sampleFriends = [
  Friend(
    id: '1',
    name: 'Emma',
    avatarAsset: 'assets/yy_1.png',
    bio:
        'Started learning piano as a child, later attracted by the diverse sounds of electronic keyboard. Recently began learning violin - the combination of these three instruments allows me to experience music\'s charm more comprehensively.',
    mainInstrument: ['Piano', 'Electronic Keyboard', 'Violin'],
    musicExperience: 8,
    favoriteGenres: ['Classical', 'Jazz'],
    practiceFrequency: '2 hours daily',
    isOnline: true,
    lastActive: DateTime.now(),
    instrumentAssets: ['assets/gq.png', 'assets/dzq.png', 'assets/xtq.png'],
    themeColor: const Color(0xFFE6B8AF), // Warm pink
    instrumentMessages: [
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎵 Piano is truly magical! Each note tells a story. I feel the chord progressions in the left hand really set the mood, while the right hand melody dances in the air ✨',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎹 Electronic Keyboard\'s sound changes are really fascinating, especially when playing modern music, different sound combinations can create unexpected effects 💫',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎻 Violin\'s sound is so beautiful, every time I play it, I feel like I can directly touch people\'s hearts. I like to use it to perform emotional chapters ❤️',
        timestamp: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎹 Piano practice tips: When playing jump notes, the wrist should be relaxed, imagine the fingers like little hammers gently striking the keys, the sound will be more crisp and pleasant ✨',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '⚡️ The rhythm accompaniment function of the electronic keyboard is very powerful. It is recommended to first familiarize yourself with the basic rhythm type, then slowly adjust the speed and force, the accompaniment effect will be better 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎻 Violin vibrato technique: The wrist should be like drawing a circle, naturally relaxed, so the sound will be rounder. I\'m practicing this recently, and I feel like I\'ve made great progress 💪',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎼 Piano daily practice arrangement: 30 minutes warm-up on the scales, 1 hour practice piece, play some of your favorite songs during rest time 📝',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎹 Electronic Keyboard practice experience: It\'s fun to try using different sounds to perform the same song every day, and it\'s a great experience 🌈',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎻 Violin daily practice: First practice 15 minutes on the scales, then practice 20 minutes on the position and vibrato, and then start practicing the piece, the order is important ✨',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😅 It\'s really hard when the left hand of the piano spans too much! I\'m practicing Chopin\'s Etude, looking for advice ~ 🆘',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '🤔 The automatic accompaniment rhythm of the electronic keyboard is always not keeping up, especially when switching chords, is there a good practice method?💭',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😣 The accuracy of the high position of the violin is not enough, often can\'t find the sound. Is there a good way to improve the position accuracy? Looking for advice 🙏',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ],
  ),
  Friend(
    id: '2',
    name: 'Jack',
    avatarAsset: 'assets/yy_2.png',
    bio:
        'Inspired by guitar performances in middle school, I started teaching myself guitar. Later, I discovered rock music, fell in love with the deep tones of bass, and also enjoy the rhythm of drums. These instruments have become my way of self-expression.',
    mainInstrument: ['Guitar', 'Bass', 'Drums'],
    musicExperience: 5,
    favoriteGenres: ['Folk', 'Rock'],
    practiceFrequency: '1 hour daily',
    isOnline: false,
    lastActive: DateTime.now().subtract(const Duration(hours: 2)),
    instrumentAssets: ['assets/jt.png', 'assets/bs.png', 'assets/jzg.png'],
    themeColor: const Color(0xFFB6D7A8), // Soft green
    instrumentMessages: [
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎸 Guitar is really my good friend! Every time I\'m in a bad mood, I can play a few chords with it to make me feel better. I like to use it to create my own music ❤️',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎸 The deep tones of bass are really charming, it\'s like the soul of the band, quietly supporting the rhythm, making the music more layered 💫',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🥁 Drums are really cool! Every time I hit the drum, I feel like I\'m full of energy, especially when it\'s in sync with the bass 💫',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '💡 Guitar fingerpicking technique sharing: Use the thumb to control the stability of the low frequency, other fingers to play the melody, so the sound will be more three-dimensional ✨',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎸 Bass finger technique: Use the index and middle fingers to alternately press the strings, keep the force uniform, so the sound will be more thick 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🥁 Drums and bass cooperation technique: The cymbal and bass rhythm should be synchronized, so the rhythm group will be more compact and powerful 💪',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎸 Guitar daily practice: 20 minutes chord switching, 20 minutes fingerpicking practice, then it\'s time for free creation 📝',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎸 Bass practice method: First use the metronome to practice the basic rhythm type, then practice with different styles of accompaniment, feel different rhythms 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🥁 Drums daily practice: First warm up for 15 minutes, then practice the basic rhythm type, finally try different variations, very satisfying ✨',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😅 Guitar chord switching is still not smooth enough, especially for some complex chords, fingers often can\'t find the right position 😣',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '🤔 Bass legato and slide technique need to be improved, looking for everyone to share some practice methods 💭',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😫 The speed of double-footing the drums is still not fast enough, is there a good practice method? My legs are sore 🥁',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ],
  ),
  Friend(
    id: '3',
    name: 'Sophie',
    avatarAsset: 'assets/yy_3.png',
    bio:
        'Violin was my enlightening instrument, teaching me patience and focus. Later I learned cello and was moved by its deep timbre. Piano helped me gain a deeper understanding of harmony.',
    mainInstrument: ['Violin', 'Cello', 'Piano'],
    musicExperience: 10,
    favoriteGenres: ['Classical', 'Chamber Music'],
    practiceFrequency: '3 hours daily',
    isOnline: true,
    lastActive: DateTime.now(),
    instrumentAssets: ['assets/xtq.png', 'assets/dtq.png', 'assets/gq.png'],
    themeColor: const Color(0xFFB4A7D6), // Soft purple
    instrumentMessages: [
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎻 Violin\'s sound is really beautiful, especially when performing emotional chapters, the delicate expression force makes people intoxicated ✨',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎻 Deep tones of cello can always touch my heart, especially when playing Bach solo suite, it seems like I can hear the voice of the soul 💫',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎹 The richness of piano harmony is really fascinating, it makes me understand the harmony structure of music more deeply ❤️',
        timestamp: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎻 Violin shift position technique: The wrist should be relaxed, imagine drawing a beautiful arc, so the pitch will be better 🌟',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎻 Cello vibrato technique: The left hand should be like massaging the string, so the sound will be more round and moving ✨',
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎹 Piano pedal use technique: Adjust the pedal according to the changes of harmony, so the sound will be more transparent 💫',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎻 Violin daily practice: Start from the scales, then practice double-tone, and then practice the piece, the order is important 📝',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎻 Cello practice experience: Practice basic skills every day, especially the practice of position and vibrato, slowly come to surprise 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎹 Piano practice method: First practice Czerny, then Bach two-part invention, and then practice big piece ✨',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😅 The pitch of the high position of the violin is always unstable, especially in the fast section, it will often go out of tune 😣',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '🤔 The resonance of the cello is not uniform enough, is there a good practice method? 💭',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😫 The combination of three-note and normal rhythm in piano is not good enough, it always doesn\'t match the beat, looking for solution 🎹',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ],
  ),
  Friend(
    id: '4',
    name: 'Lucas',
    avatarAsset: 'assets/yy_4.png',
    bio:
        'Drums are my favorite, they help me find the rhythm of life. To improve my compositions, I learned bass and guitar, and now I can write complete musical passages - it feels amazing!',
    mainInstrument: ['Drums', 'Bass', 'Guitar'],
    musicExperience: 6,
    favoriteGenres: ['Rock', 'Pop'],
    practiceFrequency: '2 hours daily',
    isOnline: true,
    lastActive: DateTime.now(),
    instrumentAssets: ['assets/jzg.png', 'assets/bs.png', 'assets/jt.png'],
    themeColor: const Color(0xFFF9CB9C), // Warm orange
    instrumentMessages: [
      InstrumentMessage(
        type: 'understanding',
        content:
            '🥁 Drums are really cool! It can drive the rhythm of the whole band! Bass and drums complement each other, guitar adds melody, the music immediately became lively ⚡️',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎸 Bass is really amazing, it\'s like a bridge connecting the drummer and other musicians, making the band\'s cooperation more closely 💫',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎸 Guitar harmony arrangement is really interesting! I\'m researching how to use guitar chord progression to enrich overall arrangement ✨',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '💪 Double-footing technique: The foot should be relaxed, use the front part of the foot to generate force. I\'m practicing jazz drum recently, this is particularly important 🎶',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎸 Bass finger technique: Use the index and middle fingers to alternately press the strings, keep the stable rhythm, so it can perfectly cooperate with the drum 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎸 Guitar rhythm type practice: Different strumming methods can create rich rhythm feeling ✨',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🥁 Every day practice: 20 minutes basic warm-up, focus on practicing double-footing and variety rhythm, feel more and more smooth 💪',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎸 Bass practice diary: Today focuses on practicing split-second rhythm, and the cooperation with the drums is getting more and more harmonious 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎸 Guitar chord practice: Practice at least once for the common chords every day, cooperate with metronome practice chord switching ✨',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😅 The high-speed double-footing of the drum is really big! Looking for everyone to share the practice method 🆘',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '🤔 Bass finger speed is not fast enough, especially in some fast songs, is there a good way?💭',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😫 Guitar right-hand force is not uniform when strumming, looking for recommendation for practice method 🎸',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ],
  ),
  Friend(
    id: '5',
    name: 'Lily',
    avatarAsset: 'assets/yy_5.png',
    bio:
        'I\'m fascinated by the saxophone\'s timbre, it seems to speak. Later when I discovered piano, I found that combining these two instruments creates a unique musical language, which excites me greatly.',
    mainInstrument: ['Saxophone', 'Piano'],
    musicExperience: 7,
    favoriteGenres: ['Jazz', 'Classical'],
    practiceFrequency: '1.5 hours daily',
    isOnline: false,
    lastActive: DateTime.now().subtract(const Duration(minutes: 30)),
    instrumentAssets: ['assets/sks.png', 'assets/gq.png'],
    themeColor: const Color(0xFFFFD5C2), // Soft apricot
    instrumentMessages: [
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎷 Saxophone sound is really charming! Every time I play, I feel like I can directly express my emotions, especially when playing jazz music 🌟',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎹 Piano and saxophone combination is really amazing, the harmony of piano can make the saxophone melody more colorful ✨',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎷 Saxophone breathing technique: Control the breath through abdominal breathing, so the long sound will be more stable 💨',
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎹 Piano improvisation technique: Improvise and create harmony based on the saxophone melody, let the music be more vivid 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎷 Saxophone daily practice: First use a balloon to practice breathing, then practice scales and improvisation section 📝',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎹 Piano harmony practice: Research different harmony progressions, prepare for saxophone improvisation 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😅 The pitch control of the high range of saxophone is not good enough, especially when playing softly, looking for advice!🎷',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '🤔 The harmony progress of piano improvisation is not smooth enough, is there a good practice suggestion?🎹',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ],
  ),
  Friend(
    id: '6',
    name: 'Oliver',
    avatarAsset: 'assets/yy_6.png',
    bio:
        'My musical journey began with violin, electronic keyboard opened my imagination to modern music, and piano enriched my musical expression. The combination of these three instruments allows me to create unique fusion works blending Eastern and Western styles.',
    mainInstrument: ['Violin', 'Electronic Keyboard', 'Piano'],
    musicExperience: 9,
    favoriteGenres: ['Folk Music', 'Fusion'],
    practiceFrequency: '2.5 hours daily',
    isOnline: true,
    lastActive: DateTime.now(),
    instrumentAssets: ['assets/xtq.png', 'assets/dzq.png', 'assets/gq.png'],
    themeColor: const Color(0xFFD5A6BD), // Soft rose
    instrumentMessages: [
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎻 Violin playing Chinese folk music is really unique! Especially when combined with the modern sound of electronic keyboard, let traditional music rejuvenate ✨',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎹 The sound changes of electronic keyboard are too rich, you can simulate various ethnic instruments, let cross-border performance more interesting 🌈',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎹 The harmony texture of piano makes the work more three-dimensional, especially helpful when adapting traditional music ❤️',
        timestamp: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎻 Violin slide technique: When playing folk music, pay special attention to the speed and force of slide, so it will be more interesting 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎹 Electronic keyboard color matching technique: When combining ethnic instruments and modern sounds, pay attention to the proportion, not to dominate ⚡️',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎹 Piano harmony arrangement: When adapting traditional music, pay attention to maintaining the characteristics of five-note scale, harmony should serve melody ✨',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎻 Today practiced violin adaptation of Erhu, the key is to imitate the sound and expression of Erhu 📝',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎹 Electronic keyboard configuration practice: Try using different sound combinations to perform the same folk music 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎹 Piano improvisation practice: Based on folk music melody improvisation, pay attention to maintaining the flavor of Chinese music ✨',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😣 Violin imitation of ethnic instrument sound is not good enough, especially imitation of Erhu tremolo 🎻',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '🤔 Electronic keyboard is not smooth when switching colors in live performance, affecting overall effect, looking for solution 💭',
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😅 Piano adaptation of traditional music harmony arrangement is not natural, how to make modern harmony and traditional melody better integrated?🎹',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ],
  ),
  Friend(
    id: '7',
    name: 'Mia',
    avatarAsset: 'assets/yy_7.png',
    bio:
        'I fell in love with the cello\'s deep timbre at first sight, it\'s like telling stories from the heart. Later I learned violin and discovered that the combination of these two instruments can create moving melodies.',
    mainInstrument: ['Cello', 'Violin'],
    musicExperience: 6,
    favoriteGenres: ['Classical', 'Chamber Music'],
    practiceFrequency: '2 hours daily',
    isOnline: false,
    lastActive: DateTime.now().subtract(const Duration(hours: 1)),
    instrumentAssets: ['assets/dtq.png', 'assets/xtq.png'],
    themeColor: const Color(0xFFA2C4C9), // Soft blue-green
    instrumentMessages: [
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎻 Deep tones of cello can always touch my heart! Every time I play Bach solo suite, I feel like I\'m completely immersed in music 💫',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎻 Violin and cello duet is really charming, the dialogue between high and low tones seems to tell a moving story ✨',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎻 Cello vibrato technique: The left hand should be like massaging the string, so the sound will be more round and moving 🌟',
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎻 Violin high position practice: Pay attention to shoulder relaxation, so the pitch will be better, the sound will also be transparent ✨',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎻 Cello daily practice: First warm up for 15 minutes, focus on position switching and vibrato, and then start practicing the piece 📝',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎻 Violin and cello duet practice: Today practiced Mozart duet with a friend, especially pay attention to the coordination 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😣 The speed of the fast section of the cello is not smooth enough, especially in the high position, looking for guidance!🎻',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '🤔 The volume balance between violin and cello is not good to grasp, is there a good suggestion?💭',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ],
  ),
  Friend(
    id: '8',
    name: 'Noah',
    avatarAsset: 'assets/yy_8.png',
    bio:
        'Jazz led me into the world of saxophone, guitar enriched my harmony, and electronic keyboard allowed me to experiment with more timbres. These instruments give me more possibilities in improvisation.',
    mainInstrument: ['Saxophone', 'Guitar', 'Electronic Keyboard'],
    musicExperience: 4,
    favoriteGenres: ['Jazz', 'Blues'],
    practiceFrequency: '2 hours daily',
    isOnline: true,
    lastActive: DateTime.now(),
    instrumentAssets: ['assets/sks.png', 'assets/jt.png', 'assets/dzq.png'],
    themeColor: const Color(0xFFE6B8AF), // Changed to a warm pink color
    instrumentMessages: [
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎷 Saxophone improvisation is really interesting, you can express it freely! With guitar and electronic keyboard accompaniment, it\'s really a perfect match 🎵',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎸 Guitar harmony progress provides infinite possibilities for improvisation, especially in jazz music ✨',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎹 The different sounds of electronic keyboard make composition more interesting, you can create unexpected effects 💫',
        timestamp: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎷 Saxophone improvisation technique: Listen to the changes of chords, use different sounds and ornaments to enrich melody ⚡️',
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎸 Guitar chord configuration: Pay attention to the tension and color of chords in jazz music, use nine and eleven chords 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎹 Electronic keyboard color matching: Use different sound combinations in different sections to make composition more layered ✨',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎷 Today practiced several classic jazz phrases, the key is to understand the music language, prepare for improvisation 📝',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎸 Guitar harmony progress practice: Recite common jazz harmony progressions, lay the foundation for improvisation 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎹 Electronic keyboard rhythm type practice: Try different styles of rhythm, let accompaniment more colorful ✨',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😅 Saxophone improvisation is always not sure which note to use, especially in complex harmony, looking for advice!🎷',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '🤔 Guitar harmony progress is not smooth, often stuck when transposing, is there a good practice method?🎸',
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😣 Electronic keyboard is not timely when switching colors in live performance, how to solve it?🎹',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ],
  ),
  Friend(
    id: '9',
    name: 'Alice',
    avatarAsset: 'assets/yy_9.png',
    bio:
        'Piano was my starting point in exploring music, while electronic keyboard led me into a broader musical world. The combination of these two instruments allows me to create works that are both traditional and modern.',
    mainInstrument: ['Piano', 'Electronic Keyboard'],
    musicExperience: 8,
    favoriteGenres: ['Classical', 'Modern'],
    practiceFrequency: '2 hours daily',
    isOnline: true,
    lastActive: DateTime.now(),
    instrumentAssets: ['assets/gq.png', 'assets/dzq.png'],
    themeColor: const Color(0xFFA2C4C9), // Soft blue-green
    instrumentMessages: [
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎹 Piano sound is really the charm of eternity! Each note is like a pearl, translucent and bright, especially when playing classical works ✨',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎹 Electronic keyboard brings me too many surprises! Different sounds allow me to try various styles of music, creative inspiration is endless 💫',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎹 Piano pedal use technique: Adjust the depth of the pedal according to different sections and harmony changes, so the sound will be more transparent 🌟',
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎹 Electronic keyboard rhythm programming: Learn to use the automatic accompaniment function, but pay attention to the changes in force, let the music have vitality ⚡️',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎹 Piano daily practice: Start from basic skills, then practice technical exercises, and then practice piece rehearsal 📝',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎹 Electronic keyboard creation practice: Today tried using different sounds to interpret the same melody, it felt very interesting 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😅 The speed of the quick eight-note jump on the piano is always not accurate enough, especially in the weak sound part, looking for guidance!🎹',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '🤔 The mixing balance of electronic keyboard in live performance is not good to grasp, is there any experience to share?💭',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ],
  ),
  Friend(
    id: '10',
    name: 'Ryan',
    avatarAsset: 'assets/yy_10.png',
    bio:
        'The perfect combination of bass and drums helped me find the rhythm of music. The chemistry of the rhythm section is the foundation that supports the whole band. Through these two instruments, I deeply understand the rhythmic essence of music.',
    mainInstrument: ['Bass', 'Drums'],
    musicExperience: 6,
    favoriteGenres: ['Rock', 'Funk'],
    practiceFrequency: '2.5 hours daily',
    isOnline: true,
    lastActive: DateTime.now(),
    instrumentAssets: ['assets/bs.png', 'assets/jzg.png'],
    themeColor: const Color(0xFFB6D7A8), // Soft green
    instrumentMessages: [
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎸 Bass is the bridge between rhythm and harmony! Working with drums creates the perfect groove foundation for any band ✨',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🥁 Drums and bass together are like a conversation in rhythm, creating a solid foundation that drives the whole band forward 💫',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎸 Bass slap technique: Keep your thumb relaxed and let it bounce off the string naturally. The key is in the wrist movement 🌟',
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🥁 Double bass drum control: Start slow with a metronome, focus on keeping steady pressure on both pedals ⚡️',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎸 Today\'s bass practice: Working on finger style alternation and ghost notes. These subtle details make the groove more alive 📝',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🥁 Drum practice routine: 30 minutes rudiments, then focus on coordinating bass drum with hi-hat patterns 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😅 Still struggling with fast tempo slap bass techniques, especially when combining with pops. Need more focused practice! 🎸',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '🤔 Finding it challenging to maintain consistent bass drum speed in complex patterns. Any tips for building stamina? 💭',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ],
  ),
  Friend(
    id: '11',
    name: 'Emma',
    avatarAsset: 'assets/yy_11.png',
    bio:
        'The combination of saxophone and electronic keyboard allows me to explore both traditional and modern expressions. The electronic keyboard\'s diverse sounds add new colors to my saxophone performances.',
    mainInstrument: ['Saxophone', 'Electronic Keyboard'],
    musicExperience: 5,
    favoriteGenres: ['Jazz', 'Electronic'],
    practiceFrequency: '2 hours daily',
    isOnline: true,
    lastActive: DateTime.now(),
    instrumentAssets: ['assets/sks.png', 'assets/dzq.png'],
    themeColor: const Color(0xFFD5A6BD), // Soft rose
    instrumentMessages: [
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎷 Saxophone\'s voice is so expressive, it\'s like singing through the instrument. Each note can tell a story ✨',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎹 Electronic keyboard opens up endless possibilities! The variety of sounds helps me explore new musical territories 💫',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎷 Working on circular breathing technique - it\'s challenging but essential for those long, flowing phrases 🌟',
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎹 Discovered some great ways to layer different keyboard sounds for a richer texture in my jazz compositions ⚡️',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎷 Daily sax routine: Long tones, overtone exercises, then working on jazz patterns and improvisation 📝',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎹 Spent today practicing keyboard voicings and creating custom patches for my upcoming performance 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😅 Still working on getting those altissimo notes consistent on the sax. Such a tricky register! 🎷',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '🤔 Need advice on balancing keyboard sounds in a live setting - sometimes the layers get muddy 💭',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ],
  ),
  Friend(
    id: '12',
    name: 'Lucas',
    avatarAsset: 'assets/yy_12.png',
    bio:
        'The perfect combination of piano and violin allows me to find unique expressions in classical music. The interplay between these two instruments has given me a deeper understanding of melody and harmony.',
    mainInstrument: ['Piano', 'Violin'],
    musicExperience: 8,
    favoriteGenres: ['Classical', 'Chamber Music'],
    practiceFrequency: '3 hours daily',
    isOnline: true,
    lastActive: DateTime.now(),
    instrumentAssets: ['assets/gq.png', 'assets/xtq.png'],
    themeColor: const Color(0xFFB4A7D6), // Soft purple
    instrumentMessages: [
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎹 Piano provides such a rich harmonic foundation, it\'s like painting with colors in music. Each chord brings new emotions ✨',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎻 Violin\'s melodic expression is incredible! The way it can soar above the piano harmonies creates magical moments 💫',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎹 Piano pedaling technique: Learning to half-pedal has opened up new possibilities for controlling sound texture 🌟',
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎻 Violin bowing technique: Working on smooth string crossings while maintaining even tone quality ⚡️',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎹 Today\'s piano focus: Bach\'s counterpoint exercises, really helps in understanding voice leading 📝',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎻 Violin practice session: Focusing on intonation in high positions and vibrato control 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😅 Struggling with balancing violin and piano volumes when playing both parts in chamber music 🎻',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '🤔 Piano arpeggios in Chopin\'s pieces are challenging, especially maintaining evenness at high speeds 💭',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ],
  ),
  Friend(
    id: '13',
    name: 'Emma',
    avatarAsset: 'assets/yy_13.png',
    bio:
        'The deep tones of the cello blend perfectly with guitar harmonies, allowing me to explore richer forms of musical expression. This unique combination brings endless possibilities to my musical compositions.',
    mainInstrument: ['Cello', 'Guitar'],
    musicExperience: 6,
    favoriteGenres: ['Folk', 'Fusion'],
    practiceFrequency: '2 hours daily',
    isOnline: false,
    lastActive: DateTime.now().subtract(const Duration(hours: 1)),
    instrumentAssets: ['assets/dtq.png', 'assets/jt.png'],
    themeColor: const Color(0xFFF9CB9C), // Warm orange
    instrumentMessages: [
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎻 Cello\'s deep, resonant voice creates such a solid foundation. It\'s like the earth beneath our musical feet ✨',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎸 Guitar\'s harmonic versatility adds such beautiful colors to the cello\'s voice. Perfect for contemporary fusion! 💫',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎻 Working on cello pizzicato technique - trying to match the articulation with guitar plucking 🌟',
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎸 Exploring fingerstyle patterns that complement cello melodies. The coordination is challenging but rewarding! ⚡️',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎻 Today\'s cello practice: Focus on bow control for smooth, singing phrases in the tenor register 📝',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎸 Guitar harmony practice: Working on jazz voicings to support cello melodies 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😅 Finding it challenging to balance cello and guitar volumes in acoustic settings 🎻',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '🤔 Need advice on preventing guitar fret buzz when playing softly under cello melodies 💭',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ],
  ),
  Friend(
    id: '14',
    name: 'William',
    avatarAsset: 'assets/yy_14.png',
    bio:
        'The combination of drums and electronic keyboard allows me to create unique modern music styles. The rich timbres of the electronic keyboard combined with drum rhythms bring endless possibilities to music.',
    mainInstrument: ['Drums', 'Electronic Keyboard'],
    musicExperience: 5,
    favoriteGenres: ['Electronic', 'Fusion'],
    practiceFrequency: '2 hours daily',
    isOnline: true,
    lastActive: DateTime.now(),
    instrumentAssets: ['assets/jzg.png', 'assets/dzq.png'],
    themeColor: const Color(0xFFE6B8AF), // Warm pink
    instrumentMessages: [
      InstrumentMessage(
        type: 'understanding',
        content:
            '🥁 Drums are the heartbeat of music! When combined with electronic sounds, it creates a perfect modern fusion ✨',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎹 Electronic keyboard\'s versatility allows me to layer different sounds over drum patterns. It\'s like painting with sound! 💫',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🥁 Working on ghost notes technique - it adds such subtle texture to the groove when combined with synth bass 🌟',
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎹 Learning to program complex arpeggios on the keyboard while maintaining steady drum patterns ⚡️',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🥁 Today\'s focus: Coordinating electronic sequences with live drum patterns. Timing is everything! 📝',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎹 Experimenting with different keyboard sounds to create unique textures in my beats 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😅 Syncing drum patterns with complex keyboard sequences is challenging. Need to work on my timing! 🥁',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '🤔 Finding the right balance between electronic and acoustic elements in my mix is tricky 💭',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ],
  ),
  Friend(
    id: '15',
    name: 'Isabella',
    avatarAsset: 'assets/yy_15.png',
    bio:
        'The combination of saxophone and guitar has helped me find my unique voice in jazz music. The complementary nature of these two instruments allows me to switch seamlessly between melody and harmony.',
    mainInstrument: ['Saxophone', 'Guitar'],
    musicExperience: 7,
    favoriteGenres: ['Jazz', 'Blues'],
    practiceFrequency: '2.5 hours daily',
    isOnline: false,
    lastActive: DateTime.now().subtract(const Duration(hours: 3)),
    instrumentAssets: ['assets/sks.png', 'assets/jt.png'],
    themeColor: const Color(0xFFB6D7A8), // Soft green
    instrumentMessages: [
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎷 Saxophone brings such soulful expression to jazz. Each note can tell a story with the right feeling ✨',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎸 Guitar chords provide the perfect harmonic foundation for sax improvisations. Love this combination! 💫',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎷 Practicing overtone exercises to improve sax tone control and flexibility in jazz phrases 🌟',
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎸 Working on chord voicings that complement saxophone melodies in different jazz standards ⚡️',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎷 Daily routine: Long tones, scale patterns, and improvisation over jazz standards 📝',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎸 Focusing on comping patterns and rhythm changes in different jazz styles 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😅 Still working on maintaining consistent tone in the altissimo register during fast passages 🎷',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '🤔 Need to improve my guitar comping when soloing on sax at the same time 💭',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ],
  ),
  Friend(
    id: '16',
    name: 'James',
    avatarAsset: 'assets/yy_16.png',
    bio:
        'Piano and electronic keyboard together open up infinite possibilities in music creation. The traditional piano techniques combined with modern electronic sounds create a unique musical landscape.',
    mainInstrument: ['Piano', 'Electronic Keyboard'],
    musicExperience: 6,
    favoriteGenres: ['Classical', 'Electronic'],
    practiceFrequency: '2.5 hours daily',
    isOnline: true,
    lastActive: DateTime.now(),
    instrumentAssets: ['assets/gq.png', 'assets/dzq.png'],
    themeColor: const Color(0xFFFFD5C2), // Soft apricot
    instrumentMessages: [
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎹 Piano and saxophone create such a rich dialogue in both classical and jazz contexts ✨',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎷 The way saxophone melodies float over piano harmonies is simply magical 💫',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎹 Working on piano voicings that support saxophone improvisation 🌟',
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎷 Practicing saxophone articulation to match piano phrasing ⚡️',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎹 Today\'s focus: Harmonizing saxophone melodies with rich piano chords 📝',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎷 Working on smooth transitions between classical and jazz styles 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😅 Coordinating breath control with piano dynamics is challenging 🎷',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '🤔 Need to improve quick switches between instruments during performance 💭',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ],
  ),
  Friend(
    id: '17',
    name: 'Sophia',
    avatarAsset: 'assets/yy_17.png',
    bio:
        'The violin\'s bright tone perfectly complements the cello\'s deep resonance. This combination allows me to explore the full range of string music expression, from light and airy to deep and profound.',
    mainInstrument: ['Violin', 'Cello'],
    musicExperience: 8,
    favoriteGenres: ['Classical', 'Contemporary'],
    practiceFrequency: '3 hours daily',
    isOnline: true,
    lastActive: DateTime.now(),
    instrumentAssets: ['assets/xtq.png', 'assets/dtq.png'],
    themeColor: const Color(0xFFA2C4C9), // Soft blue-green
    instrumentMessages: [
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎻 Violin\'s sound is really beautiful, especially when performing emotional chapters, the delicate expression force makes people intoxicated ✨',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎻 Deep tones of cello can always touch my heart, especially when playing Bach solo suite, it seems like I can hear the voice of the soul 💫',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎹 The richness of piano harmony is really fascinating, it makes me understand the harmony structure of music more deeply ❤️',
        timestamp: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎻 Violin shift position technique: The wrist should be relaxed, imagine drawing a beautiful arc, so the pitch will be better 🌟',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎻 Cello vibrato technique: The left hand should be like massaging the string, so the sound will be more round and moving ✨',
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎹 Piano pedal use technique: Adjust the pedal according to the changes of harmony, so the sound will be more transparent 💫',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎻 Violin daily practice: Start from the scales, then practice double-tone, and then practice the piece, the order is important 📝',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎻 Cello practice experience: Practice basic skills every day, especially the practice of position and vibrato, slowly come to surprise 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎹 Piano practice method: First practice Czerny, then Bach two-part invention, and then practice big piece ✨',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😅 The pitch of the high position of the violin is always unstable, especially in the fast section, it will often go out of tune 😣',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '🤔 The resonance of the cello is not uniform enough, is there a good practice method? 💭',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😫 The combination of three-note and normal rhythm in piano is not good enough, it always doesn\'t match the beat, looking for solution 🎹',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ],
  ),
  Friend(
    id: '18',
    name: 'Ethan',
    avatarAsset: 'assets/yy_18.png',
    bio:
        'Bass and drums form the perfect rhythm section foundation. These two instruments have helped me deeply understand musical groove and create solid rhythmic foundations for bands.',
    mainInstrument: ['Bass', 'Drums'],
    musicExperience: 5,
    favoriteGenres: ['Rock', 'Funk'],
    practiceFrequency: '2.5 hours daily',
    isOnline: false,
    lastActive: DateTime.now().subtract(const Duration(hours: 2)),
    instrumentAssets: ['assets/bs.png', 'assets/jzg.png'],
    themeColor: const Color(0xFFD5A6BD), // Soft rose
    instrumentMessages: [
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎸 Bass lines lock in with drum patterns to drive the groove forward 💫',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎸 Practicing tight rhythmic patterns between both instruments ⚡️',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      InstrumentMessage(
        type: 'practice',
        content: '🥁 Today\'s focus: Funk grooves and syncopated rhythms 📝',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎸 Working on locking in complex rhythm patterns as a section 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😅 Maintaining steady tempo when switching between instruments 🥁',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '🤔 Need to improve independence between hands and feet coordination 💭',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ],
  ),
  Friend(
    id: '19',
    name: 'Grace',
    avatarAsset: 'assets/yy_19.png',
    bio:
        'The combination of cello and electronic keyboard allows me to explore both traditional and modern musical expressions. The rich timbres of the electronic keyboard add new dimensions to the cello\'s warm tone.',
    mainInstrument: ['Cello', 'Electronic Keyboard'],
    musicExperience: 7,
    favoriteGenres: ['Classical', 'Contemporary'],
    practiceFrequency: '2.5 hours daily',
    isOnline: true,
    lastActive: DateTime.now(),
    instrumentAssets: ['assets/dtq.png', 'assets/dzq.png'],
    themeColor: const Color(0xFFB4A7D6), // Soft purple
    instrumentMessages: [
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎻 Deep tones of cello can always touch my heart, especially when playing Bach solo suite, it seems like I can hear the voice of the soul 💫',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎹 The richness of piano harmony is really fascinating, it makes me understand the harmony structure of music more deeply ❤️',
        timestamp: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎻 Violin shift position technique: The wrist should be relaxed, imagine drawing a beautiful arc, so the pitch will be better 🌟',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎻 Cello vibrato technique: The left hand should be like massaging the string, so the sound will be more round and moving ✨',
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎹 Piano pedal use technique: Adjust the pedal according to the changes of harmony, so the sound will be more transparent 💫',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎻 Violin daily practice: Start from the scales, then practice double-tone, and then practice the piece, the order is important 📝',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎻 Cello practice experience: Practice basic skills every day, especially the practice of position and vibrato, slowly come to surprise 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎹 Piano practice method: First practice Czerny, then Bach two-part invention, and then practice big piece ✨',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😅 The pitch of the high position of the violin is always unstable, especially in the fast section, it will often go out of tune 😣',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '🤔 The resonance of the cello is not uniform enough, is there a good practice method? 💭',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😫 The combination of three-note and normal rhythm in piano is not good enough, it always doesn\'t match the beat, looking for solution 🎹',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ],
  ),
  Friend(
    id: '20',
    name: 'Daniel',
    avatarAsset: 'assets/yy_20.png',
    bio:
        'The combination of saxophone and piano helps me find the perfect balance in jazz music. The piano\'s harmonic textures combined with the saxophone\'s improvisational expression create music with both depth and expressiveness.',
    mainInstrument: ['Saxophone', 'Piano'],
    musicExperience: 8,
    favoriteGenres: ['Jazz', 'Fusion'],
    practiceFrequency: '3 hours daily',
    isOnline: true,
    lastActive: DateTime.now(),
    instrumentAssets: ['assets/sks.png', 'assets/gq.png'],
    themeColor: const Color(0xFFB6D7A8), // Soft green
    instrumentMessages: [
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎷 Saxophone\'s expressive power in jazz is limitless! The way it flows over piano harmonies creates pure magic ✨',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎹 Piano\'s rich harmonic possibilities provide the perfect foundation for sax improvisation 💫',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎷 Working on saxophone articulation to match piano\'s rhythmic comping patterns 🌟',
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎹 Exploring advanced voicings on piano to support saxophone melodies ⚡️',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎷 Daily routine: Long tones on sax, followed by improvisation over complex chord changes 📝',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎹 Piano practice: Working on left-hand independence while comping for sax solos 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😅 Challenging to maintain consistent breath support on sax during extended solo sections 🎷',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '🤔 Need to improve coordination between piano comping and sax lead lines when playing both 💭',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ],
  ),
  Friend(
    id: '21',
    name: 'Sophia',
    avatarAsset: 'assets/yy_21.png',
    bio:
        'The combination of cello and electronic keyboard allows me to explore the perfect fusion of traditional and modern styles. The rich timbres of the electronic keyboard add new colors to the cello\'s deep resonance.',
    mainInstrument: ['Cello', 'Electronic Keyboard'],
    musicExperience: 7,
    favoriteGenres: ['Modern Classical', 'Electronic'],
    practiceFrequency: '2.5 hours daily',
    isOnline: false,
    lastActive: DateTime.now().subtract(const Duration(hours: 2)),
    instrumentAssets: ['assets/dtq.png', 'assets/dzq.png'],
    themeColor: const Color(0xFFD5A6BD), // Soft rose
    instrumentMessages: [
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎻 Cello\'s warm, rich tone creates a beautiful contrast with electronic textures ✨',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎹 Electronic keyboard opens up endless possibilities for layering with cello melodies 💫',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎻 Exploring extended cello techniques to blend with electronic sounds 🌟',
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎹 Working on real-time sound manipulation while maintaining cello performance ⚡️',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎻 Today\'s focus: Integrating cello phrases with electronic loops and textures 📝',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎹 Experimenting with different electronic sounds to complement cello timbre 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😅 Finding the right balance between acoustic cello and electronic elements 🎻',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '🤔 Need to improve timing when playing with electronic sequences and loops 💭',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ],
  ),
  Friend(
    id: '22',
    name: 'Alexander',
    avatarAsset: 'assets/yy_22.png',
    bio:
        'The combination of violin and guitar allows me to switch freely between classical and modern music. This pairing brings a unique perspective to my musical compositions.',
    mainInstrument: ['Violin', 'Guitar'],
    musicExperience: 6,
    favoriteGenres: ['Classical', 'Folk'],
    practiceFrequency: '2 hours daily',
    isOnline: true,
    lastActive: DateTime.now(),
    instrumentAssets: ['assets/xtq.png', 'assets/jt.png'],
    themeColor: const Color(0xFFA2C4C9), // Soft blue-green
    instrumentMessages: [
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎻 Violin and guitar create such a unique blend of timbres. Classical meets contemporary! ✨',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎸 Love how guitar harmonies can support and enhance violin melodies in different styles 💫',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎻 Working on violin pizzicato to match guitar articulation in folk pieces 🌟',
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎸 Practicing fingerstyle patterns that complement violin melodies ⚡️',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎻 Today\'s focus: Blending violin and guitar tones in chamber music arrangements 📝',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎸 Working on cross-genre arrangements combining classical and folk elements 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😅 Balancing violin projection with guitar accompaniment is tricky 🎻',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '🤔 Need to improve quick transitions between instruments during performances 💭',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ],
  ),
  Friend(
    id: '23',
    name: 'Victoria',
    avatarAsset: 'assets/yy_23.png',
    bio:
        'The combination of drums and saxophone gives me a unique way to express myself in jazz. Being able to control both rhythm and melody, this dual role adds more layers to the music.',
    mainInstrument: ['Drums', 'Saxophone'],
    musicExperience: 7,
    favoriteGenres: ['Jazz', 'Funk'],
    practiceFrequency: '2.5 hours daily',
    isOnline: false,
    lastActive: DateTime.now().subtract(const Duration(hours: 1)),
    instrumentAssets: ['assets/jzg.png', 'assets/sks.png'],
    themeColor: const Color(0xFFB4A7D6), // Soft purple
    instrumentMessages: [
      InstrumentMessage(
        type: 'understanding',
        content:
            '🥁 Drums and sax together bridge the gap between rhythm and melody in jazz ✨',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎷 The way saxophone phrases can weave through drum patterns is pure magic 💫',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🥁 Working on polyrhythmic patterns to support saxophone improvisations 🌟',
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎷 Practicing breath control while maintaining internal rhythm for drumming ⚡️',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🥁 Today\'s focus: Coordinating drum solos with saxophone phrases 📝',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎷 Working on rhythmic saxophone patterns that complement drum grooves 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😅 Maintaining steady time while switching between instruments is challenging 🥁',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '🤔 Need to improve endurance when playing both instruments in one session 💭',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ],
  ),
  Friend(
    id: '24',
    name: 'Benjamin',
    avatarAsset: 'assets/yy_24.png',
    bio:
        'The perfect combination of bass and electronic keyboard allows me to control both bass lines and harmonies. This combination plays a crucial role in modern music production.',
    mainInstrument: ['Bass', 'Electronic Keyboard'],
    musicExperience: 5,
    favoriteGenres: ['Electronic', 'Funk'],
    practiceFrequency: '2 hours daily',
    isOnline: true,
    lastActive: DateTime.now(),
    instrumentAssets: ['assets/bs.png', 'assets/dzq.png'],
    themeColor: const Color(0xFFE6B8AF), // Warm pink
    instrumentMessages: [
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎸 Bass and electronic keyboard create such a solid foundation for modern music ✨',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎹 Love how synth bass and acoustic bass can blend in electronic music 💫',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎸 Working on bass lines that complement electronic sequences 🌟',
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎹 Exploring different synth sounds to layer with bass grooves ⚡️',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎸 Today\'s focus: Creating dynamic bass lines with electronic elements 📝',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎹 Experimenting with keyboard arrangements over bass foundations 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😅 Syncing bass playing with electronic sequences needs work 🎸',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '🤔 Finding the right balance between electronic and acoustic elements 💭',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ],
  ),
  Friend(
    id: '25',
    name: 'Olivia',
    avatarAsset: 'assets/yy_25.png',
    bio:
        'The combination of piano and saxophone helps me find balance between classical and jazz music. This pairing of instruments allows me to switch effortlessly between different musical styles.',
    mainInstrument: ['Piano', 'Saxophone'],
    musicExperience: 8,
    favoriteGenres: ['Classical', 'Jazz'],
    practiceFrequency: '3 hours daily',
    isOnline: true,
    lastActive: DateTime.now(),
    instrumentAssets: ['assets/gq.png', 'assets/sks.png'],
    themeColor: const Color(0xFFB6D7A8), // Soft green
    instrumentMessages: [
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎹 Piano and saxophone create such a rich dialogue in both classical and jazz contexts ✨',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎷 The way saxophone melodies float over piano harmonies is simply magical 💫',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎹 Working on piano voicings that support saxophone improvisation 🌟',
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎷 Practicing saxophone articulation to match piano phrasing ⚡️',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎹 Today\'s focus: Harmonizing saxophone melodies with rich piano chords 📝',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎷 Working on smooth transitions between classical and jazz styles 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😅 Coordinating breath control with piano dynamics is challenging 🎷',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '🤔 Need to improve quick switches between instruments during performance 💭',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ],
  ),
  Friend(
    id: '26',
    name: 'James',
    avatarAsset: 'assets/yy_26.png',
    bio:
        'The combination of violin and electronic keyboard helps me bridge the gap between traditional and modern music. The rich timbres of the electronic keyboard bring new expressive possibilities to the violin.',
    mainInstrument: ['Violin', 'Electronic Keyboard'],
    musicExperience: 6,
    favoriteGenres: ['Classical', 'Electronic'],
    practiceFrequency: '2.5 hours daily',
    isOnline: false,
    lastActive: DateTime.now().subtract(const Duration(hours: 3)),
    instrumentAssets: ['assets/xtq.png', 'assets/dzq.png'],
    themeColor: const Color(0xFFF9CB9C), // Warm orange
    instrumentMessages: [
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎻 Violin and electronic keyboard create fascinating contemporary soundscapes ✨',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎹 Electronic sounds add new dimensions to traditional violin music 💫',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎻 Exploring extended violin techniques with electronic effects 🌟',
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      InstrumentMessage(
        type: 'technique',
        content: '🎹 Working on live electronic processing of violin sounds ⚡️',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎻 Today\'s focus: Integrating violin with electronic loops and textures 📝',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎹 Experimenting with different synth sounds to complement violin 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😅 Maintaining precise timing with electronic backing tracks 🎻',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '🤔 Need to improve balance between acoustic and electronic elements 💭',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ],
  ),
  Friend(
    id: '27',
    name: 'Charlotte',
    avatarAsset: 'assets/yy_27.png',
    bio:
        'The unique combination of cello and drums has opened new horizons in my modern music composition. The deep resonance of the cello blends perfectly with the dynamic drum patterns.',
    mainInstrument: ['Cello', 'Drums'],
    musicExperience: 7,
    favoriteGenres: ['Modern', 'Fusion'],
    practiceFrequency: '2 hours daily',
    isOnline: true,
    lastActive: DateTime.now(),
    instrumentAssets: ['assets/dtq.png', 'assets/jzg.png'],
    themeColor: const Color(0xFFD5A6BD), // Soft rose
    instrumentMessages: [
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎻 Cello and drums create such unique rhythmic textures in contemporary music ✨',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🥁 Love how drum patterns can enhance cello\'s natural rhythm 💫',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎻 Working on percussive cello techniques to blend with drums 🌟',
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🥁 Practicing subtle drum patterns that support cello melodies ⚡️',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎻 Today\'s focus: Rhythmic cello patterns with drum accompaniment 📝',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🥁 Exploring different groove patterns to support cello lines 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😅 Balancing cello projection with drum dynamics is challenging 🎻',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content: '🤔 Need to improve coordination between both instruments 💭',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ],
  ),
  Friend(
    id: '28',
    name: 'Michael',
    avatarAsset: 'assets/yy_28.png',
    bio:
        'The combination of guitar and saxophone has helped me find my unique voice in jazz and blues music. The complementary nature of these two instruments allows me to switch seamlessly between melody and harmony.',
    mainInstrument: ['Guitar', 'Saxophone'],
    musicExperience: 8,
    favoriteGenres: ['Jazz', 'Blues'],
    practiceFrequency: '2.5 hours daily',
    isOnline: true,
    lastActive: DateTime.now(),
    instrumentAssets: ['assets/jt.png', 'assets/sks.png'],
    themeColor: const Color(0xFFA2C4C9), // Soft blue-green
    instrumentMessages: [
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎸 Guitar and saxophone blend perfectly in jazz and blues contexts ✨',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎷 The way saxophone lines weave through guitar chords is magical 💫',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎸 Working on chord voicings that complement saxophone melodies 🌟',
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎷 Practicing saxophone phrasing over guitar accompaniment ⚡️',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎸 Today\'s focus: Comping patterns for saxophone improvisation 📝',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎷 Working on blues scales and jazz patterns with guitar backing 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😅 Coordinating breathing with guitar chord changes is tricky 🎷',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '🤔 Need to improve quick transitions between lead and rhythm roles 💭',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ],
  ),
  Friend(
    id: '29',
    name: 'Emily',
    avatarAsset: 'assets/yy_29.png',
    bio:
        'The perfect combination of piano and cello helps me find unique expressions in classical music. This pairing of instruments allows me to fully convey the emotional depth of music.',
    mainInstrument: ['Piano', 'Cello'],
    musicExperience: 9,
    favoriteGenres: ['Classical', 'Chamber Music'],
    practiceFrequency: '3 hours daily',
    isOnline: false,
    lastActive: DateTime.now().subtract(const Duration(hours: 2)),
    instrumentAssets: ['assets/gq.png', 'assets/dtq.png'],
    themeColor: const Color(0xFFB4A7D6), // Soft purple
    instrumentMessages: [
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎹 Piano and cello create such deep emotional resonance in classical music ✨',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
      InstrumentMessage(
        type: 'understanding',
        content:
            '🎻 The way cello melodies interweave with piano harmonies is pure poetry 💫',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎹 Working on pedaling techniques to support cello phrases 🌟',
        timestamp: DateTime.now().subtract(const Duration(hours: 20)),
      ),
      InstrumentMessage(
        type: 'technique',
        content:
            '🎻 Practicing cello tone production to blend with piano textures ⚡️',
        timestamp: DateTime.now().subtract(const Duration(hours: 10)),
      ),
      InstrumentMessage(
        type: 'practice',
        content: '🎹 Today\'s focus: Beethoven sonatas for piano and cello 📝',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      ),
      InstrumentMessage(
        type: 'practice',
        content:
            '🎻 Working on chamber music repertoire and ensemble balance 🎵',
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content:
            '😅 Maintaining consistent tempo when switching instruments 🎹',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      InstrumentMessage(
        type: 'difficulty',
        content: '🤔 Need to improve coordination in rubato passages 💭',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ],
  ),
];
