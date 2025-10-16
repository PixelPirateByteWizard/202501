import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../services/game_data_service.dart';
import '../models/resource.dart';

class QuickCraftScreen extends StatefulWidget {
  const QuickCraftScreen({super.key});

  @override
  State<QuickCraftScreen> createState() => _QuickCraftScreenState();
}

class _QuickCraftScreenState extends State<QuickCraftScreen> {
  final GameDataService _gameDataService = GameDataService();
  List<Resource> _resources = [];
  List<CraftingRecipe> _recipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final resources = await _gameDataService.getResources();
    setState(() {
      _resources = resources;
      _recipes = _getAvailableRecipes();
      _isLoading = false;
    });
  }

  List<CraftingRecipe> _getAvailableRecipes() {
    return [
      CraftingRecipe(
        id: 'basic_gear',
        name: 'Basic Gear',
        icon: '⚙️',
        description: 'Essential component for clockwork mechanisms',
        inputs: {'brass_ingot': 2, 'energy': 5},
        outputs: {'gears': 1},
        craftTime: const Duration(minutes: 2),
        category: 'Components',
      ),
      CraftingRecipe(
        id: 'precision_spring',
        name: 'Precision Spring',
        icon: '🌀',
        description: 'High-quality spring for delicate mechanisms',
        inputs: {'brass_ingot': 1, 'quartz_sand': 3},
        outputs: {'springs': 1},
        craftTime: const Duration(minutes: 5),
        category: 'Components',
      ),
      CraftingRecipe(
        id: 'energy_crystal',
        name: 'Energy Crystal',
        icon: '💎',
        description: 'Concentrated energy storage device',
        inputs: {'stardust': 2, 'quartz_sand': 5, 'energy': 20},
        outputs: {'energy_crystal': 1},
        craftTime: const Duration(minutes: 10),
        category: 'Advanced',
      ),
      CraftingRecipe(
        id: 'automaton_core',
        name: 'Automaton Core',
        icon: '🤖',
        description: 'Central processing unit for automatons',
        inputs: {'gears': 5, 'energy_crystal': 1, 'springs': 3},
        outputs: {'automaton_core': 1},
        craftTime: const Duration(minutes: 15),
        category: 'Advanced',
      ),
      CraftingRecipe(
        id: 'repair_kit',
        name: 'Repair Kit',
        icon: '🔧',
        description: 'Emergency repairs for damaged equipment',
        inputs: {'brass_ingot': 1, 'raw_rubber': 2},
        outputs: {'repair_kit': 1},
        craftTime: const Duration(minutes: 3),
        category: 'Tools',
      ),
    ];
  }

  bool _canCraft(CraftingRecipe recipe) {
    for (final entry in recipe.inputs.entries) {
      final resource = _resources.firstWhere(
        (r) => r.id == entry.key,
        orElse: () => const Resource(id: '', name: '', icon: '', amount: 0),
      );
      if (resource.amount < entry.value) return false;
    }
    return true;
  }

  void _craftItem(CraftingRecipe recipe) {
    if (!_canCraft(recipe)) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.slateBlue,
        title: Text(
          'Craft ${recipe.name}?',
          style: const TextStyle(color: AppColors.vintageGold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipe.description,
              style: const TextStyle(color: AppColors.lavenderWhite),
            ),
            const SizedBox(height: 16),
            const Text(
              'Required Materials:',
              style: TextStyle(
                color: AppColors.vintageGold,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...recipe.inputs.entries.map(
              (entry) => Text(
                '• ${entry.key}: ${entry.value}',
                style: const TextStyle(color: AppColors.lavenderWhite),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Craft Time: ${recipe.craftTime.inMinutes}m ${recipe.craftTime.inSeconds % 60}s',
              style: const TextStyle(color: AppColors.vintageGold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.lavenderWhite),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startCrafting(recipe);
            },
            child: const Text('Craft'),
          ),
        ],
      ),
    );
  }

  void _startCrafting(CraftingRecipe recipe) {
    // Consume resources
    final updatedResources = _resources.map((resource) {
      final consumeAmount = recipe.inputs[resource.id] ?? 0;
      if (consumeAmount > 0) {
        return resource.copyWith(amount: resource.amount - consumeAmount);
      }
      return resource;
    }).toList();

    // Add output resources
    for (final entry in recipe.outputs.entries) {
      final existingIndex = updatedResources.indexWhere((r) => r.id == entry.key);
      if (existingIndex != -1) {
        updatedResources[existingIndex] = updatedResources[existingIndex]
            .copyWith(amount: updatedResources[existingIndex].amount + entry.value);
      } else {
        updatedResources.add(Resource(
          id: entry.key,
          name: entry.key.replaceAll('_', ' ').toUpperCase(),
          icon: recipe.icon,
          amount: entry.value,
        ));
      }
    }

    setState(() {
      _resources = updatedResources;
    });

    _gameDataService.saveResources(_resources);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${recipe.name} crafted successfully!'),
        backgroundColor: AppColors.statusOptimal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.vintageGold),
        ),
      );
    }

    final categories = _recipes.map((r) => r.category).toSet().toList();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.deepNavy, AppColors.slateBlue],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.lavenderWhite,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Quick Craft',
                        style: Theme.of(context).textTheme.displaySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Resource Summary
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available Resources',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        children: _resources.take(6).map((resource) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.deepNavy,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.vintageGold.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  resource.icon,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${resource.amount}',
                                  style: const TextStyle(
                                    color: AppColors.vintageGold,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Crafting Recipes
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categories.length,
                  itemBuilder: (context, categoryIndex) {
                    final category = categories[categoryIndex];
                    final categoryRecipes = _recipes
                        .where((r) => r.category == category)
                        .toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            category,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppColors.vintageGold,
                            ),
                          ),
                        ),
                        ...categoryRecipes.map((recipe) {
                          final canCraft = _canCraft(recipe);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GlassCard(
                              onTap: canCraft ? () => _craftItem(recipe) : null,
                              child: Opacity(
                                opacity: canCraft ? 1.0 : 0.5,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: AppColors.deepNavy,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: canCraft
                                              ? AppColors.vintageGold
                                              : AppColors.lavenderWhite.withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          recipe.icon,
                                          style: const TextStyle(fontSize: 24),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            recipe.name,
                                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            recipe.description,
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: AppColors.lavenderWhite.withValues(alpha: 0.7),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.schedule,
                                                size: 14,
                                                color: AppColors.vintageGold,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${recipe.craftTime.inMinutes}m',
                                                style: const TextStyle(
                                                  color: AppColors.vintageGold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (canCraft)
                                      const Icon(
                                        Icons.build_circle,
                                        color: AppColors.vintageGold,
                                      )
                                    else
                                      const Icon(
                                        Icons.lock,
                                        color: AppColors.lavenderWhite,
                                        size: 20,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CraftingRecipe {
  final String id;
  final String name;
  final String icon;
  final String description;
  final Map<String, int> inputs;
  final Map<String, int> outputs;
  final Duration craftTime;
  final String category;

  const CraftingRecipe({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.inputs,
    required this.outputs,
    required this.craftTime,
    required this.category,
  });
}