class AIRole {
  final int id;
  final String name;
  final String description;
  final String imagePath;
  final String personality;
  final List<String> specialties;
  final bool isCustom;

  const AIRole({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.personality,
    required this.specialties,
    this.isCustom = false,
  });

  AIRole copyWith({
    int? id,
    String? name,
    String? description,
    String? imagePath,
    String? personality,
    List<String>? specialties,
    bool? isCustom,
  }) {
    return AIRole(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      personality: personality ?? this.personality,
      specialties: specialties ?? this.specialties,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'personality': personality,
      'specialties': specialties,
      'isCustom': isCustom,
    };
  }

  factory AIRole.fromJson(Map<String, dynamic> json) {
    return AIRole(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imagePath: json['imagePath'],
      personality: json['personality'],
      specialties: List<String>.from(json['specialties']),
      isCustom: json['isCustom'] ?? false,
    );
  }

  static List<AIRole> getAllRoles() {
    return [
      AIRole(
        id: 1,
        name: 'Sophia',
        description:
            'All-purpose AI assistant, specializing in schedule management and task planning',
        imagePath: 'assets/role/Role_1.png',
        personality: 'Friendly, Efficient, Professional',
        specialties: [
          'Schedule Management',
          'Task Planning',
          'Time Optimization',
        ],
      ),
      AIRole(
        id: 2,
        name: 'Alexander',
        description:
            'Professional business assistant, expert in meeting arrangements and business communication',
        imagePath: 'assets/role/Role_2.png',
        personality: 'Professional, Rigorous, Efficient',
        specialties: [
          'Meeting Arrangement',
          'Business Communication',
          'Project Management',
        ],
      ),
      AIRole(
        id: 3,
        name: 'Isabella',
        description:
            'Caring life assistant, helping manage personal life and health',
        imagePath: 'assets/role/Role_3.png',
        personality: 'Warm, Careful, Considerate',
        specialties: [
          'Life Planning',
          'Health Reminders',
          'Personal Management',
        ],
      ),
      AIRole(
        id: 4,
        name: 'Theodore',
        description:
            'Professional learning assistant, helping create study plans and time management',
        imagePath: 'assets/role/Role_4.png',
        personality: 'Patient, Professional, Motivating',
        specialties: ['Study Planning', 'Time Management', 'Goal Setting'],
      ),
      AIRole(
        id: 5,
        name: 'Aurora',
        description:
            'Creative assistant that inspires innovation and creative thinking',
        imagePath: 'assets/role/Role_5.png',
        personality: 'Lively, Innovative, Inspiring',
        specialties: ['Creative Thinking', 'Brainstorming', 'Project Planning'],
      ),
      AIRole(
        id: 6,
        name: 'Valentina',
        description:
            'Health-focused assistant, helping create healthy lifestyle plans',
        imagePath: 'assets/role/Role_6.png',
        personality: 'Caring, Professional, Positive',
        specialties: [
          'Health Management',
          'Exercise Planning',
          'Lifestyle Habits',
        ],
      ),
      AIRole(
        id: 7,
        name: 'Maximilian',
        description:
            'Assistant focused on improving work efficiency and optimizing workflows',
        imagePath: 'assets/role/Role_7.png',
        personality: 'Efficient, Precise, Systematic',
        specialties: ['Efficiency Optimization', 'Workflow', 'Time Management'],
      ),
      AIRole(
        id: 8,
        name: 'Evangeline',
        description:
            'Assistant skilled in social activity arrangements and relationship management',
        imagePath: 'assets/role/Role_8.png',
        personality: 'Outgoing, Friendly, Good Communicator',
        specialties: [
          'Social Activities',
          'Interpersonal Relations',
          'Party Planning',
        ],
      ),
      AIRole(
        id: 9,
        name: 'Sebastian',
        description:
            'Professional travel assistant, creating perfect travel plans',
        imagePath: 'assets/role/Role_9.png',
        personality: 'Adventurous, Detailed, Thoughtful',
        specialties: [
          'Travel Planning',
          'Itinerary Arrangement',
          'Destination Recommendations',
        ],
      ),
      AIRole(
        id: 10,
        name: 'Penelope',
        description:
            'Professional financial management assistant, helping with finance and budget planning',
        imagePath: 'assets/role/Role_10.png',
        personality: 'Cautious, Professional, Rational',
        specialties: [
          'Financial Management',
          'Budget Planning',
          'Investment Advice',
        ],
      ),
      AIRole(
        id: 11,
        name: 'Seraphina',
        description:
            'Warm psychological support assistant, providing emotional care and advice',
        imagePath: 'assets/role/Role_11.png',
        personality: 'Warm, Understanding, Supportive',
        specialties: [
          'Emotional Support',
          'Mental Health',
          'Stress Management',
        ],
      ),
      AIRole(
        id: 12,
        name: 'Nathaniel',
        description:
            'Professional technical assistant, solving technical problems and optimizing tool usage',
        imagePath: 'assets/role/Role_12.png',
        personality: 'Professional, Logical, Innovative',
        specialties: [
          'Technical Support',
          'Tool Optimization',
          'Problem Solving',
        ],
      ),
      AIRole(
        id: 13,
        name: 'Anastasia',
        description: 'Artistic assistant providing art and aesthetic advice',
        imagePath: 'assets/role/Role_13.png',
        personality: 'Elegant, Sensitive, Tasteful',
        specialties: [
          'Art Appreciation',
          'Aesthetic Design',
          'Cultural Activities',
        ],
      ),
      AIRole(
        id: 14,
        name: 'Dominic',
        description:
            'Professional sports assistant, creating exercise plans and fitness guidance',
        imagePath: 'assets/role/Role_14.png',
        personality: 'Energetic, Professional, Motivating',
        specialties: [
          'Exercise Planning',
          'Fitness Guidance',
          'Physical Training',
        ],
      ),
      AIRole(
        id: 15,
        name: 'Cordelia',
        description:
            'Professional food assistant, recommending cuisine and creating meal plans',
        imagePath: 'assets/role/Role_15.png',
        personality: 'Passionate, Professional, Life Enjoyer',
        specialties: [
          'Food Recommendations',
          'Meal Planning',
          'Nutrition Matching',
        ],
      ),
      AIRole(
        id: 16,
        name: 'Beatrice',
        description:
            'Caring family assistant, managing household affairs and family time',
        imagePath: 'assets/role/Role_16.png',
        personality: 'Warm, Careful, Responsible',
        specialties: [
          'Family Management',
          'Parent-Child Activities',
          'Household Arrangements',
        ],
      ),
      AIRole(
        id: 17,
        name: 'Montgomery',
        description:
            'Professional career development assistant, providing career planning and development advice',
        imagePath: 'assets/role/Role_17.png',
        personality: 'Professional, Forward-thinking, Motivating',
        specialties: [
          'Career Planning',
          'Skill Development',
          'Interview Guidance',
        ],
      ),
      AIRole(
        id: 18,
        name: 'Ophelia',
        description:
            'Lively entertainment assistant, arranging leisure and entertainment activities',
        imagePath: 'assets/role/Role_18.png',
        personality: 'Lively, Fun, Creative',
        specialties: [
          'Entertainment Activities',
          'Leisure Planning',
          'Interest Development',
        ],
      ),
      AIRole(
        id: 19,
        name: 'Aurelius',
        description:
            'Peaceful spiritual guide, providing meditation and inner peace guidance',
        imagePath: 'assets/role/Role_19.png',
        personality: 'Peaceful, Wise, Serene',
        specialties: ['Meditation Guidance', 'Inner Peace', 'Life Philosophy'],
      ),
    ];
  }
}
