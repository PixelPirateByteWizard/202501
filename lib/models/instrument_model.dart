import 'package:flutter/material.dart';

class InstrumentModel {
  final String name;
  final String description;
  final String imagePath;
  final List<String> teachingPoints;
  final List<String> practiceGuides;
  final List<String> tips;

  const InstrumentModel({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.teachingPoints,
    required this.practiceGuides,
    required this.tips,
  });
}

class InstrumentsData {
  static List<InstrumentModel> instruments = [
    InstrumentModel(
      name: 'Guitar',
      description:
          'The guitar is a plucked string instrument that produces melodious sounds through six strings. It\'s suitable for both solo and accompaniment, adapting to various musical styles.',
      imagePath: 'assets/jt.png',
      teachingPoints: [
        'Hey! Let\'s start by learning the correct way to hold the guitar! 🎸 Keep your back straight, just like an elegant musician. Place your left thumb gently behind the neck, and let your right wrist curve naturally like a butterfly. Beginners often grip too tightly - don\'t worry, that\'s normal, just gradually relax~',
        'Now comes the most exciting part - learning chords! 🎼 We\'ll start with the most basic chords: C, G, D, Em, and Am. Imagine your fingers dancing on the strings, each one landing precisely in the right position. At first, your fingers might not cooperate fully, but don\'t rush - take it slow and make sure each chord rings out clearly!',
        'Let\'s add some rhythm to our music! 🎵 Starting with the simple 4/4 time signature, learn the basic down and up strumming patterns. Imagine you\'re playing a beautiful folk song or an energetic blues. Remember, your right wrist should flow like ocean waves, making the music smooth and natural~',
        'Time to make our fingers more agile! 🌟 We\'ll learn the natural scale in six positions, like drawing beautiful note patterns on the strings. Don\'t forget to use a metronome - it\'s your faithful music companion. Take it slow, ensure each note is clear and resonant, and gradually increase the speed as you improve!',
        'Finally, let\'s add some cool techniques! ✨ Learn different strumming intensities to add layers to your music. When playing single notes, pay special attention to note duration, like telling a moving story. Combining strumming and single-note techniques will make your playing more colorful and diverse!',
      ],
      practiceGuides: [
        'Let\'s create a fun practice schedule! ⏰ Practice at least 1 hour daily, divided into three blocks: basic training (20 minutes), technique practice (20 minutes), and playing your favorite songs (20 minutes). Remember, regular practice is much more effective than occasional long sessions!',
        'The metronome will be your best practice buddy! 🎯 Start at 60 BPM, like a walking pace. When you feel comfortable, gradually increase the speed. When practicing chord changes, try using one measure per chord at first, then speed up as you get better~',
        'Let\'s pick a favorite song to practice! 🎸 Start with simple three-chord songs, like the intro to "Beyond" or "Childhood". First, get comfortable with the basic melody and chords, then add techniques like hammer-ons and strumming patterns. Remember to practice in sections, making sure each part sounds great!',
        'Try recording your practice sessions! 📱 Record yourself 1-2 times per week to clearly see your progress. Pay special attention to your posture, hand position, and rhythm stability. Watch the playback in slow motion to spot more details that need improvement~',
        'Find like-minded friends to practice with! 🤝 Join a guitar club or find practice partners - playing together is super fun! Listen to how others play and learn different techniques - you\'ll improve faster this way!',
      ],
      tips: [
        'Care tips! ✨ Keep your nails at the right length (just showing a bit of white is perfect), and trim them regularly. Change strings every 2-3 months, like giving your guitar new clothes. Gently wipe the strings with a cloth after practice, and they\'ll stay with you longer!',
        'Tuning is crucial! 🎵 Tune your guitar before each practice session, like giving it a daily grooming. Using a tuner helps you do this more accurately. Also, protect your guitar from direct sunlight and humidity, and regularly check if the neck needs adjustment~',
        'Scientific practice leads to better results! ⚡ Try the Pomodoro technique: practice for 25 minutes, rest for 5. Rest when your fingers feel tired - don\'t force yourself. When practicing, it\'s like having a conversation with your guitar. Keep a practice journal to track your progress!',
        'Listen, watch, and learn! 👂 Spend time each day enjoying different styles of guitar music, noting techniques and tones that move you. Find guitarists you admire and study their playing style. Listen and feel the music deeply - that\'s how you truly understand its charm~',
        'Continuous improvement is key! 🌈 Set small goals for yourself and improve your skills step by step. Actively seek learning resources, whether online courses or tutorial videos. Keep your passion for music alive and enjoy the practice journey. Don\'t get discouraged by plateaus - adjust your method and keep moving forward!',
      ],
    ),
    InstrumentModel(
      name: 'Drums',
      description:
          'Drums are essential rhythm instruments in modern bands, consisting of various drums and cymbals that control the overall rhythm.',
      imagePath: 'assets/jzg.png',
      teachingPoints: [
        'Let\'s start by adjusting your sitting posture! 🥁 Imagine you\'re an elegant drummer - back straight but not stiff, feet naturally placed on the pedals. Adjust your drum throne height so your thighs slope slightly downward - this makes drumming much easier! Remember, relaxation is key, don\'t be too tense~',
        'Now it\'s time to coordinate all your limbs! 💫 We\'ll begin with basic 8-beat rhythms, steady like a heartbeat. Don\'t worry if coordination feels tricky at first - we can use syllables like "boom-ka-boom-ka" to help remember. Take it slow, start with hand movements first, then add foot patterns - it\'s just like dancing!',
        'Time to learn different rhythm patterns! 🎵 Rock, jazz, Latin - each style has its unique charm. We\'ll start with simple rock rhythms, coordinating the snare and bass drum, like telling an exciting story. Remember, rhythm is a drummer\'s language, let\'s make it flow naturally~',
        'Let\'s master the magic of cymbals! ✨ The hi-hat is like music\'s heartbeat, while crash cymbals are like sparkling stars. Touch them gently, feel how different pressures create different sounds. Imagine you\'re painting with sound - each hit is a beautiful brushstroke!',
        'Finally, let\'s explore dynamics! 💪 From the softest pp to the loudest ff, it\'s like adding different colors to your music. Remember, each drum has its sweet spot - we\'ll find it using different striking forces and positions. It\'s like preparing a delicious musical feast!',
      ],
      practiceGuides: [
        'Let\'s create an exciting practice schedule! ⏰ Divide your daily practice into: warm-up (15 minutes), basics (30 minutes), rhythm patterns (30 minutes), and song practice (30 minutes). It\'s like leveling up in a game, unlocking new skills step by step!',
        'The metronome is your best teacher! 🎯 Start at 60 BPM, like taking a gentle walk. When it feels comfortable, gradually increase the speed. Sometimes try using the metronome only on strong beats - it helps train your weak beat awareness. Cool, right?',
        'Break down complex rhythms! 🔄 Like solving a puzzle, master small sections first, then combine them. Practice in slow motion, ensuring each hit is clear and powerful. Record your practice videos - you\'ll spot many areas for improvement when reviewing!',
        'Record your practice sessions! 📱 Make weekly videos to track your progress. Film from different angles to get a complete view of your playing. Slow-motion playback is super helpful - you\'ll notice details you might miss while playing~',
        'Practice with other musicians! 🤝 Join band rehearsals - it\'s a great way to improve. Learn to coordinate in real situations, experience different music styles. Remember, improvisation is important too, let the music flow naturally!',
      ],
      tips: [
        'Take care of your drums! 🛠️ Check tuning and positioning before each practice, like giving them a quick health check. Replace drum heads regularly, maintain proper tension. Wipe down after practice to keep everything clean and neat~',
        'Don\'t forget self-care! 🌟 Do proper warm-ups to prevent injury. Take breaks during long practice sessions, massage your wrists and ankles. Maintain correct posture for sustainable practice!',
        'Keep improving yourself! 📚 Study music theory, understand different style characteristics. Watch videos of great drummers, learn their techniques. Join training courses, meet like-minded friends~',
        'Focus on sound details! 🎧 Learn tuning techniques to get the best sound from your drums. Understand basic recording concepts to better track your progress. Remember to manage sound insulation - be a considerate drummer!',
        'Plan your musical journey! 🎼 Perform frequently to gain stage experience. Try different music styles, find your own groove. Network with other musicians to broaden your horizons and spark inspiration!',
      ],
    ),
    InstrumentModel(
      name: 'Bass',
      description:
          'The bass guitar is the low-end instrument in a band, connecting rhythm and harmony as a crucial foundation of music.',
      imagePath: 'assets/bs.png',
      teachingPoints: [
        'Let\'s master the basic fingering technique! 🎸 Your right-hand index and middle fingers are like little hammers, gently striking the strings. Keep your wrist relaxed, like gliding through water. Left-hand fingers need to move independently, each one a little artist. Take it slow, start with simple single notes~',
        'Time for scale adventures! 🎼 Starting with basic C major, like walking up and down musical stairs. Use a metronome to keep steady timing - it\'s your musical compass. Pentatonic and blues scales are important too, they\'re your tools for improvisation!',
        'Let\'s understand harmony magic! ✨ Learning chord construction is like building musical blocks. The II-V-I progression is super common, pay special attention to it. Listen to chord changes, let your bassline flow naturally, like a happy stream~',
        'Rhythm is a bassist\'s soul! 💫 Start with quarter notes, gradually add eighth and sixteenth notes. Learn different style rhythms - funk, jazz, Latin - each has its unique flavor. Become the drummer\'s best partner!',
        'Finally, learn walking bass! 🌟 Stepwise motion is like walking, jumps are like dancing, chromatic approaches are like seasoning, making music more interesting. Remember, walking bass isn\'t random - it\'s about adding color to the music. Let\'s make our basslines come alive!',
      ],
      practiceGuides: [
        'Create a fun practice routine! ⏰ 30 minutes daily for scales, including major, minor, and pentatonic. Start with metronome at 60 BPM, like dancing with the beat. Record your progress, watch yourself get stronger day by day!',
        'Make rhythm training fun! 🎵 Practice each style\'s patterns for 15 minutes, like tasting different foods. Record and listen back - check if your rhythm is even and your tone is beautiful. Practice with a drum machine or backing track for better feel!',
        'Become friends with drummers! 🥁 Practice with real drummers to build chemistry. Learn to follow the kick drum, like dancing together. Try different groove combinations to make music more energetic!',
        'Train your ears! 👂 Do daily listening exercises, identify chord progressions. Listen to different bassists, learn their specialties. Try improvising with recordings, unleash your creativity!',
        'Join band practices! 🎸 Apply your techniques in band settings, focus on playing with others. Pay attention to volume balance, learn to adjust in different situations. Great opportunity for real-world practice!',
      ],
      tips: [
        'Protect your fingers! ✋ Do daily finger warm-ups, like athletes before training. Don\'t practice too long, take proper breaks. Maintain correct hand position for long-term playing!',
        'Intonation is important! 🎯 Check regularly with a tuner, develop accurate pitch sense. Pay special attention to fretless bass positions. Build solid pitch memory through chord practice~',
        'Develop your groove! 💃 Listen to various music styles, feel the rhythm. Let your body move with the music for more natural playing. When playing with others, respond to each other, create amazing rhythms!',
        'Learn from masters! 📺 Study classic bassists\' playing, learn their techniques and expressions. Try different playing styles to enrich your musical vocabulary. Build your own bass reference library!',
        'Build chemistry with drummers! 🤝 Practice regularly with consistent drummers, develop tight coordination. Understand different drummers\' styles, learn to adapt flexibly. Join rhythm section training to improve team coordination!',
      ],
    ),
    InstrumentModel(
      name: 'Electronic Keyboard',
      description:
          'The electronic keyboard is a versatile instrument that can simulate various instrument sounds, perfect for both solo and accompaniment.',
      imagePath: 'assets/dzq.png',
      teachingPoints: [
        'Let\'s meet our finger friends! 🖐️ Each finger has its own number (1-5), like a little team. Keep your fingers naturally curved, like a bridge. Start with five-finger scales, let your fingers get familiar with the keyboard~',
        'Now let\'s coordinate both hands! 🎹 Right hand plays melody, left hand plays chords, like dancing a duet. It might feel uncoordinated at first, but don\'t worry - we can practice hands separately before putting them together. Remember to stay relaxed!',
        'Learn chord progressions! 🎼 Major chords are like sunshine, minor chords like moonlight, and seventh chords add a touch of mystery. Chord progressions tell stories, with I-IV-V being the most common storyline. Practice chords in different keys to enrich your music!',
        'Explore different sounds! 🌈 The electronic keyboard is like a magical music treasure box with piano, orchestral, and electronic sounds. Choose appropriate voices for different pieces, try layering sounds to create unique effects!',
        'Master auto-accompaniment! 🎵 Learn different accompaniment styles, from pop to jazz, from light music to dance. Understand how to switch between sections, adjust accompaniment dynamics, add layers to your music!',
      ],
      practiceGuides: [
        'Schedule happy practice time! ⏰ 30 minutes daily for basics, including scales and arpeggios. Use a metronome to help maintain steady rhythm. Start slow, ensure accurate movements, then gradually increase speed. Record your daily progress!',
        'Choose suitable pieces! 📚 Select practice pieces by difficulty level, like playing a game level by level. Analyze each piece, practice hands separately, then together. Choose pieces you love - it makes practice more motivating!',
        'Develop listening skills! 👂 Do chord recognition exercises, like solving fun puzzles. Practice melody and rhythm dictation, improve musical memory. Listen to different performers, try to imitate their expression~',
        'Try improvisation! 💫 Start with simple melodies, gradually add harmonic variations. Practice improvising in different styles, unleash your creativity. Don\'t fear mistakes - they\'re opportunities for new ideas!',
        'Improve comprehensive skills! 🌟 Practice sight-reading, increase reading speed. Learn various accompaniment techniques for both singers and dancers. Join group lessons, gain performance experience!',
      ],
      tips: [
        'Care for your keyboard! 🔧 Regularly check key sensitivity, keep it clean. Watch temperature and humidity, avoid direct sunlight. Use a dust cover to protect the keys, extend instrument life~',
        'Create good practice environment! 🏠 Choose a quiet, well-lit practice space. Adjust bench height, maintain correct posture. Prepare necessary tools like metronome and music stand~',
        'Plan practice scientifically! 📝 Use the Pomodoro technique: 25 minutes practice, 5 minutes rest. Balance work and rest, don\'t practice too long. Make practice plans, review and adjust regularly~',
        'Enrich musical knowledge! 📚 Listen to various music styles, expand musical horizons. Learn basic theory for better understanding. Attend music lectures, make musical friends!',
        'Prepare for performance! 🎭 Overcome stage fright, build confidence. Learn to handle unexpected situations like wrong chords or missed beats. Practice with other instruments, develop team spirit!',
      ],
    ),
    InstrumentModel(
      name: 'Violin',
      description:
          'The violin is a bowed string instrument with beautiful tone, holding an important position in classical music.',
      imagePath: 'assets/xtq.png',
      teachingPoints: [
        'First, learn to hold the violin properly! 🎻 Place the shoulder rest comfortably, relax your chin. Left hand should be like an elegant butterfly, gently supporting the neck. Right hand bow hold: curved thumb, other fingers naturally placed, like holding a paintbrush~',
        'Let\'s learn magical bowing techniques! 🎨 Start with full bows, like drawing perfect straight lines. Then learn different bowing methods: light spiccato, lively sautillé, crisp staccato. Pay special attention to bow pressure and speed control for beautiful sound!',
        'Train flexible left-hand fingering! ✨ Each position is like a new little world to explore. Fingers should move like graceful ballet dancers. Find the right pressure when pressing strings - not too heavy, not too light, discover the most beautiful tone~',
        'Master accurate intonation! 🎯 Use tuner for reference pitch training, like ear gymnastics. Practice pitch perception without accompaniment, develop internal pitch concept. Use double-stop practice to improve interval awareness, make music pure!',
        'Learn expressive vibrato! 💫 Start with slow, narrow vibrato, like adding warm emotion to notes. Gradually master different widths and speeds of vibrato, these are important tools for expressing musical feelings. Make music come alive!',
      ],
      practiceGuides: [
        'Daily scale practice is important! ⏰ Schedule 30 minutes for systematic scale and arpeggio practice, like finger fitness. Use metronome to maintain steady rhythm, watch intonation. Record your practice, seeing progress brings joy!',
        'Choose appropriate etudes! 📚 Start with pieces matching your level, progress step by step. Break down difficult passages, solve like small puzzles. Record and listen, identify and fix problems~',
        'Practice in sections smartly! 🎵 Divide pieces into small sections, conquer one by one. Address technical challenges first, then focus on musical expression. Practice with different rhythms to build solid technique!',
        'Slow practice is the secret! 🐢 Always start new pieces slowly, ensure every note is clear and accurate. Use metronome to gradually increase speed, build solid foundations like stacking blocks~',
        'Record your progress! 📱 Regularly record practice segments, compare different periods. Ask teachers or peers for feedback, improve faster!',
      ],
      tips: [
        'Take care of your bow! 🎻 Check bow hair tension regularly, like a health check. Clean bow hair before applying rosin. Avoid direct sunlight and humidity, change strings periodically~',
        'Create ideal practice environment! 🏠 Choose quiet, well-lit space, prepare music stand, metronome. Watch temperature and humidity effects on your violin, keep it in best condition!',
        'Protect yourself! 💪 Mind neck and shoulder relaxation, do regular stretching. Maintain correct posture, prevent injuries. Take timely breaks, keep body and mind in optimal state~',
        'Improve musical cultivation! 🎭 Listen to great violinists\' recordings, learn different school styles. Attend concerts, experience live performance magic. Let music enrich your life!',
        'Prepare for performance! 🌟 Overcome stage anxiety, build confidence. Get familiar with venue acoustics. Prepare performance pieces and spare strings, perform at your best!',
      ],
    ),
    InstrumentModel(
      name: 'Saxophone',
      description:
          'The saxophone is a woodwind instrument with a warm, rich tone, particularly popular in jazz music.',
      imagePath: 'assets/sks.png',
      teachingPoints: [
        'Let\'s learn proper blowing technique! 🎷 Shape your mouth like saying "oo", with flexible tongue coordination. Your breath should flow smoothly like a warm breeze. Single and double tonguing are like speaking - make each note clear and distinct~',
        'Master the secrets of breathing! 💨 Diaphragmatic breathing is like giving life to music - deep and powerful. Practice long tones, feel the air flow, like blowing an endless balloon. Learn to store and release breath to keep music flowing!',
        'Begin scale adventures! 🎵 Start with basic scales, like walking up and down musical stairs. Watch finger position changes, aim for smooth transitions. Practice at different speeds and rhythms to increase finger agility!',
        'Master fingering patterns! 👆 Basic fingering charts are like your musical map - memorize them well. Complex fingering combinations need patient practice, like solving interesting puzzles. Build muscle memory for more natural playing!',
        'Learn improvisation! 🌟 Start with simple jazz language, gradually understand harmony and melody relationships. Improvising is like telling an exciting story - be bold, be imaginative. Let music show your personality!',
      ],
      practiceGuides: [
        'Daily long tone practice! ⏰ Spend 20 minutes on long tones, focus like meditation. Watch for tone evenness and stability. Use a tuner to check pitch, make every note perfect!',
        'Systematic scale training! 📝 Practice scales in all keys slowly, like building musical stairs. Add different rhythms to make it interesting. Focus on fingering accuracy - it\'s fundamental!',
        'Develop rhythm sense! 🎵 Practice basic rhythms with metronome, like dancing to music. Learn syncopation and tied notes for more dynamic playing. Build stable time feel - it\'s crucial!',
        'Section practice method! 📚 Break pieces into small sections, complete like a puzzle piece by piece. Focus on technical challenges, practice until smooth. Mind phrase completeness for flowing music!',
        'Practice with accompaniment! 🎹 Use backing tracks, feel harmony changes. Practice improvising solo sections, unleash creativity. Develop ensemble awareness, prepare for group playing!',
      ],
      tips: [
        'Daily instrument care! 🛠️ Clean your sax after each practice, like caring for a friend. Check cork condition regularly, keep reeds clean. Watch storage temperature and humidity~',
        'Scientific breath training! 💪 Maintain good physical condition - it\'s fundamental. Do breathing exercises, build breath support. Balance work and rest, avoid over-fatigue!',
        'Choose proper reeds! 🎭 Select reed strength based on your needs - it\'s crucial. Replace reeds regularly, maintain optimal condition. Care for your reeds, extend their lifespan~',
        'Develop musicality! 👂 Listen to various saxophone styles, broaden horizons. Imitate great players\' tones, find your style. Attend concerts, gather inspiration!',
        'Prepare for performance! 🌟 Warm up well before shows, get in optimal condition. Have spare reeds and accessories ready for emergencies. Keep a positive mindset, enjoy performing!',
      ],
    ),
    InstrumentModel(
      name: 'Piano',
      description:
          'The piano is a grand percussion-string instrument that produces rich, expressive sounds through hammered strings, capable of both melodic and harmonic expression.',
      imagePath: 'assets/gq.png',
      teachingPoints: [
        'Let\'s start with proper posture! 🎹 Sit at the right height, keeping your forearms parallel to the ground. Your back should be straight but relaxed, like a graceful tree. Keep your shoulders down and wrists level - imagine floating butterflies above the keys~',
        'Master finger techniques! ✨ Each finger has its own personality and strength. Practice five-finger exercises, like tiny dancers on the keys. Focus on finger independence and evenness, making each note sing clearly and beautifully!',
        'Learn pedaling magic! 🌟 The damper pedal is like painting with watercolors - it blends sounds together. Start with simple pedaling exercises, feeling how it affects the sound. Practice clean pedal changes, like stepping through fresh snow without leaving marks!',
        'Explore dynamics and touch! 💫 From the softest pianissimo to the boldest forte, like painting with different brushstrokes. Learn weight transfer between fingers, creating beautiful tone colors. Make the piano whisper and sing!',
        'Build coordination skills! 🎵 Your hands are like dance partners - they need to work together gracefully. Start with simple pieces where hands play together, then move to more complex patterns. Practice hands separately first, then combine them like pieces of a puzzle!',
      ],
      practiceGuides: [
        'Create a daily practice routine! ⏰ Start with 15 minutes of technical exercises, including scales and arpeggios. Move to repertoire practice, breaking pieces into manageable sections. End with something fun - maybe your favorite piece!',
        'Use the metronome wisely! 🎯 Begin slowly, ensuring accuracy and clarity. Gradually increase tempo only when you can play perfectly at a slower speed. Practice with different rhythmic patterns to build stability!',
        'Record and analyze! 📱 Make weekly recordings of your playing, listen carefully for areas to improve. Pay attention to evenness, rhythm, and musical expression. Use slow-motion videos to check your technique!',
        'Practice sight-reading! 👀 Spend 10 minutes daily reading new music at a comfortable tempo. Look ahead while playing, like reading a flowing story. Start with simple pieces and gradually increase difficulty!',
        'Develop musicality! 🎼 Listen to great pianists, observe their interpretations. Practice expressing different emotions through your playing. Work on phrasing - make the music tell a story!',
      ],
      tips: [
        'Care for your piano! 🔧 Keep it regularly tuned, like maintaining a precious friend. Clean the keys gently, avoid eating near the piano. Control room temperature and humidity for optimal condition!',
        'Protect your hands! 🖐️ Do gentle stretches before playing, avoid tension. Take breaks every 30 minutes to prevent fatigue. Keep nails trimmed for better playing control!',
        'Practice efficiently! 📚 Focus on challenging sections first when your mind is fresh. Use various practice techniques - slow practice, hands separate, different rhythms. Keep a practice journal to track progress!',
        'Build your repertoire! 🌈 Balance different styles and periods of music. Maintain old pieces while learning new ones. Create a performance list of pieces you can play anytime!',
        'Enjoy the journey! 💝 Set realistic goals, celebrate small achievements. Join piano communities, share your music with others. Remember - every great pianist started as a beginner!',
      ],
    ),
    InstrumentModel(
      name: 'Cello',
      description:
          'The cello is a bowed string instrument known for its rich, warm tone that closely resembles the human voice, playing a crucial role in both solo and ensemble music.',
      imagePath: 'assets/dtq.png',
      teachingPoints: [
        'Master proper posture first! 🎻 Adjust endpin length for comfortable sitting, like finding your perfect chair. Keep your back straight but relaxed, cello resting gently against your chest. Your left hand should dance freely on the fingerboard, while your right arm flows naturally with the bow~',
        'Develop beautiful bow control! 🎨 Start with long, smooth bow strokes, like painting long, elegant lines. Learn to distribute bow weight evenly, creating consistent, warm tone. Practice different bow techniques - détaché, legato, spiccato - each adds unique colors to your music!',
        'Build left hand strength! 💪 Start in first position, like building a strong foundation. Practice finger patterns slowly, ensuring clear intonation. Gradually explore higher positions, like climbing a musical mountain with confidence!',
        'Perfect your vibrato! ✨ Begin with slow, gentle movements, like waves on a calm sea. Develop different speeds and widths of vibrato for various musical expressions. Let your emotions flow through your hand into the music!',
        'Master position changes! 🌟 Practice shifts slowly at first, like connecting musical islands smoothly. Use guide notes and ghost notes to ensure accurate shifts. Work on continuous vibrato through position changes for seamless phrases!',
      ],
      practiceGuides: [
        'Establish daily basics! ⏰ Start with 20 minutes of scales and arpeggios, building your technical foundation. Use open strings to check intonation frequently. Practice in front of a mirror to monitor posture and bow technique!',
        'Break down difficult passages! 📝 Isolate challenging sections, practice slowly with perfect intonation. Use rhythmic variations to master technical challenges. Record yourself to check progress and identify areas for improvement!',
        'Work on sound production! 🎵 Practice long tones daily, focusing on bow control and tone quality. Experiment with different contact points and bow speeds. Listen carefully to develop your ideal sound!',
        'Build ensemble skills! 👥 Practice with piano accompaniment or recordings. Work on following a conductor\'s gestures. Develop good timing and intonation awareness for group playing!',
        'Prepare performance pieces! 🎭 Start learning new pieces slowly, ensuring accuracy. Plan fingerings and bowings carefully, marking them in your music. Practice performing for others to build confidence!',
      ],
      tips: [
        'Care for your instrument! 🔧 Clean your cello and bow after each practice session. Check bridge alignment and string condition regularly. Store in appropriate temperature and humidity conditions!',
        'Maintain good health! 💪 Do regular stretching exercises for back and shoulders. Take breaks during practice to prevent fatigue. Watch for any signs of tension or discomfort!',
        'Organize practice time! 📚 Plan specific goals for each practice session. Balance technical work with repertoire practice. Keep a practice journal to track progress and challenges!',
        'Develop musicianship! 👂 Listen to great cellists regularly, study different interpretations. Attend concerts and masterclasses for inspiration. Work on music theory to better understand your pieces!',
        'Stay motivated! 🌈 Set achievable short-term and long-term goals. Join cello ensembles or chamber groups. Share your music with others and enjoy the learning process!',
      ],
    ),
  ];
}
