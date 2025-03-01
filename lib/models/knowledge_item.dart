import 'package:flutter/material.dart';

class KnowledgeItem {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final List<String> keyPoints;
  final List<String> detailContent;
  final int readCount;
  final bool isFeatured;

  const KnowledgeItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.keyPoints,
    required this.detailContent,
    this.readCount = 0,
    this.isFeatured = false,
  });

  // 手动实现 fromJson 方法
  factory KnowledgeItem.fromJson(Map<String, dynamic> json) {
    return KnowledgeItem(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon:
          IconData(json['icon_codepoint'] as int, fontFamily: 'MaterialIcons'),
      keyPoints: List<String>.from(json['key_points'] as List),
      detailContent: List<String>.from(json['detail_content'] as List),
      readCount: json['read_count'] as int? ?? 0,
      isFeatured: json['is_featured'] as bool? ?? false,
    );
  }

  // 手动实现 toJson 方法
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon_codepoint': icon.codePoint,
      'key_points': keyPoints,
      'detail_content': detailContent,
      'read_count': readCount,
      'is_featured': isFeatured,
    };
  }
}

// 预设的知识库数据
final List<KnowledgeItem> knowledgeItems = [
  KnowledgeItem(
    id: '1',
    title: 'Environmental Science Basics',
    description:
        'Understanding ecosystem principles and the importance of environmental protection',
    icon: Icons.nature,
    keyPoints: [
      'Ecosystem Components',
      'Natural Cycles',
      'Importance of Biodiversity',
      'Environmental Protection Principles'
    ],
    detailContent: [
      "Hey! Let's explore the amazing ecosystem together! 🌍 Did you know there are over 8 million different species on Earth? They're all vital members of this vast network of life!",
      "The ecosystem is like a precise orchestra, with each organism playing its part. 🎵 Plants, animals, microorganisms, and the environment interact harmoniously to create life's symphony!",
      "Fascinating fact: Tropical rainforests cover only 6% of Earth's land but house over half of the planet's species! 🌴 That's the magic of biodiversity!",
      "Nature has an incredible cycling system! ☀️ Sunlight, air, and water flow between organisms like a never-ending relay race. Plants absorb sunlight to produce nutrients, animals eat plants for energy, decomposers turn waste into nutrients... the cycle continues!",
      "Have you noticed? Every organism contributes silently! 🦋 Bees pollinate, birds spread seeds, earthworms loosen soil... there are no 'small roles' in nature!",
      "Scientists discovered: Healthy ecosystems better resist climate change! 🌡️ Like a strong immune system, helping Earth defend against environmental threats.",
      "Eco-friendly tips: Protecting the environment is simple! 🌱 Save water, sort waste, reduce plastic use... these small actions help protect ecosystems!",
      "Let's become Earth's guardians together! 🦸‍♂️ Remember: Environmental protection isn't a one-person job, it needs all our efforts!",
      "Gentle reminder: Earth is our only home! 🏡 When we cherish every drop of water and every unit of electricity, we're protecting this beautiful planet for future generations! 💚"
    ],
    isFeatured: true,
  ),
  KnowledgeItem(
    id: '2',
    title: 'Waste Sorting Guide',
    description:
        'Master correct waste sorting methods and practice environmental protection concepts',
    icon: Icons.delete_outline,
    keyPoints: [
      'Basic Principles of Waste Sorting',
      'Common Waste Classification Methods',
      'Significance of Waste Sorting',
      'Daily Practice Implementation'
    ],
    detailContent: [
      "Did you know? The world produces over 2 billion tons of waste annually! 🌍 Through proper sorting, we can turn over 60% of waste back into resources!",
      "Welcome to Waste Sorting Class! 📚 Today we'll meet four waste families: Recyclables, Food Waste, Hazardous Waste, and Other Waste. Each family has its characteristics!",
      "Recyclables are like sleeping treasures! ♻️ Paper becomes new paper, plastic bottles become sportswear, glass bottles can be reused... that's turning waste into wealth!",
      "Interesting fact: A glass bottle takes millions of years to decompose, but recycling takes just days! ⚡ And a plastic bag might take 500 years to fully decompose!",
      "Food waste is amazing too! 🥬 Through composting, it becomes nutritious soil for plants. Even a banana peel can make a big difference!",
      "Special reminder: Be careful with hazardous waste like batteries and light bulbs! ⚠️ They contain environmentally harmful substances and must be specially treated. Environmental protection starts with proper hazardous waste handling!",
      "Sorting tip: Not sure what type of waste it is? Check the product's material description and recycling symbol! 🔍 Take it slow, practice makes perfect!",
      "Eco-knowledge: One person's waste sorting can reduce 300kg of carbon emissions yearly! 🌱 That's equivalent to planting 15 trees!",
      "Remember: Waste sorting seems small, but it connects to Earth's future! 🌟 Let's act together to make Earth cleaner!"
    ],
  ),
  KnowledgeItem(
    id: '3',
    title: 'Recycling',
    description:
        'Explore resource recycling methods to reduce environmental pollution',
    icon: Icons.recycling,
    keyPoints: [
      'Basic Concepts of Recycling',
      'Recyclable Items Processing',
      'Innovative Recycling Methods',
      'Importance of Circular Economy'
    ],
    detailContent: [
      "Hey! Have you heard of the 'circular economy'? 🌟 It's a super cool economic model where resources keep cycling, just like nature's ecological cycles!",
      "Interesting discovery: Recycling one aluminum can saves 96% of the energy needed to make a new one! ⚡ Plus, aluminum can be recycled infinitely - that's the magic of recycling!",
      "Creative recycling: Old jeans can become fashionable bags, used tires can become children's playground equipment, old newspapers can become art... 🎨 Recycling is full of surprises!",
      "Tech innovation: Some sneakers are now made from ocean waste! 🌊 This not only cleans the ocean but creates fashionable products - two birds with one stone!",
      "Life hacks: Glass jars can become vases, old T-shirts can become shopping bags, damaged utensils can become planters... 🎁 Let's spark creativity together!",
      "Did you know? Paper can be recycled up to 7 times! 📄 Every ton of recycled paper saves 17 trees! Let's treasure every piece of paper!",
      "Recycling is not just eco-friendly, it saves money too! 💰 For example: Making your own compost can beautify your garden, renovating old furniture can save the cost of buying new ones!",
      "Friendly reminder: Before throwing things away, think if they could serve another purpose? 🤔 Creativity and environmental protection are often just a thought away!",
      "Let's join the recycling movement! ♻️ Remember: Earth's resources are limited, but creativity is unlimited!"
    ],
  ),
  KnowledgeItem(
    id: '4',
    title: 'Green Lifestyle',
    description:
        'Learn eco-friendly living tips to create a sustainable lifestyle',
    icon: Icons.eco,
    keyPoints: [
      'Daily Eco-friendly Tips',
      'Low-carbon Transportation',
      'Energy and Water Conservation',
      'Green Consumption Concepts'
    ],
    detailContent: [
      "Hi! Want to know how to live more eco-friendly? 🌱 Actually, a green lifestyle not only protects the environment but makes our lives healthier and more quality-focused!",
      "Eco-knowledge: Walking or cycling instead of driving can reduce about 2 tons of carbon emissions annually! 🚲 Plus it exercises your body - multiple benefits!",
      "Energy-saving tips: Using LED bulbs can save 90% of electricity! 💡 Remember to turn off unused appliances - it's eco-friendly and saves money!",
      "Water resource tips: Using water-saving faucets and toilets can save tens of thousands of liters annually! 💧 Collecting rainwater for plants is also great eco-behavior!",
      "Green diet: Choosing seasonal fruits and vegetables is not only fresh and delicious but reduces transportation carbon emissions! 🥗 Moderately reducing meat consumption is more Earth-friendly!",
      "Home eco-tips: Growing plants at home not only purifies air but improves mood! 🌿 Choosing eco-friendly cleaning products is better for family and environment!",
      "Shopping advice: Bring reusable shopping bags, reject excessive packaging! 🛍️ Choose durable items over disposables - that's smart consumption!",
      "Interesting fact: If every household reduced energy consumption by 10%, it would be like planting millions of trees! 🌳 Small changes, big help!",
      "Let's create a sustainable lifestyle together! 🌈 Remember: What's good for the environment is good for you!"
    ],
  ),
];
