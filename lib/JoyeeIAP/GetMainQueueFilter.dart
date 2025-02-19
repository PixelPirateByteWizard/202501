class InitializeAdvancedAnalogyManager {
  final String itemId;
  final String name;
  final String type;
  final int coinAmount;
  final String price;
  final String description;
  final String locale;
  final String category;

  const InitializeAdvancedAnalogyManager({
    required this.itemId,
    required this.name,
    required this.type,
    required this.coinAmount,
    required this.price,
    required this.description,
    required this.locale,
    required this.category,
  });
}

const List<InitializeAdvancedAnalogyManager> shopInventory =
    <InitializeAdvancedAnalogyManager>[
  // Consumable Items - Basic Series
  InitializeAdvancedAnalogyManager(
    itemId: 'Joyee1_5',
    name: 'Basic Pack',
    type: 'consumable',
    coinAmount: 500,
    price: '5.99',
    description: 'Basic Pack',
    locale: 'en_US',
    category: 'basic',
  ),
  InitializeAdvancedAnalogyManager(
    itemId: 'Joyee1_15',
    name: 'Standard Pack',
    type: 'consumable',
    coinAmount: 1500,
    price: '15.99',
    description: 'Standard Pack',
    locale: 'en_US',
    category: 'basic',
  ),
  InitializeAdvancedAnalogyManager(
    itemId: 'Joyee1_19',
    name: 'Premium Pack',
    type: 'consumable',
    coinAmount: 2000,
    price: '19.99',
    description: 'Premium Pack',
    locale: 'en_US',
    category: 'basic',
  ),

  // Bundle Series
  InitializeAdvancedAnalogyManager(
    itemId: 'Joyee2_6',
    name: 'Starter Bundle',
    type: 'consumable',
    coinAmount: 700,
    price: '6.99',
    description: 'Starter Bundle',
    locale: 'en_US',
    category: 'bundle',
  ),
  InitializeAdvancedAnalogyManager(
    itemId: 'Joyee2_19',
    name: 'Advanced Bundle',
    type: 'consumable',
    coinAmount: 2000,
    price: '19.99',
    description: 'Advanced Bundle',
    locale: 'en_US',
    category: 'bundle',
  ),
  InitializeAdvancedAnalogyManager(
    itemId: 'Joyee2_29',
    name: 'Ultimate Bundle',
    type: 'consumable',
    coinAmount: 3000,
    price: '29.99',
    description: 'Ultimate Bundle',
    locale: 'en_US',
    category: 'bundle',
  ),

  // Collection Series
  InitializeAdvancedAnalogyManager(
    itemId: 'Joyee3_8',
    name: 'Mini Collection',
    type: 'consumable',
    coinAmount: 800,
    price: '8.99',
    description: 'Mini Collection',
    locale: 'en_US',
    category: 'collection',
  ),
  InitializeAdvancedAnalogyManager(
    itemId: 'Joyee3_19',
    name: 'Essential Collection',
    type: 'consumable',
    coinAmount: 2000,
    price: '19.99',
    description: 'Essential Collection',
    locale: 'en_US',
    category: 'collection',
  ),
  InitializeAdvancedAnalogyManager(
    itemId: 'Joyee3_39',
    name: 'Mega Collection',
    type: 'consumable',
    coinAmount: 4000,
    price: '39.99',
    description: 'Mega Collection',
    locale: 'en_US',
    category: 'collection',
  ),

  // Audio Series
  InitializeAdvancedAnalogyManager(
    itemId: 'Joyee4_8',
    name: 'Sound Pack',
    type: 'consumable',
    coinAmount: 800,
    price: '8.99',
    description: 'Sound Pack',
    locale: 'en_US',
    category: 'audio',
  ),
  InitializeAdvancedAnalogyManager(
    itemId: 'Joyee4_19',
    name: 'Audio Collection',
    type: 'consumable',
    coinAmount: 2000,
    price: '19.99',
    description: 'Audio Collection',
    locale: 'en_US',
    category: 'audio',
  ),
  InitializeAdvancedAnalogyManager(
    itemId: 'Joyee4_39',
    name: 'Pro Audio Bundle',
    type: 'consumable',
    coinAmount: 4000,
    price: '39.99',
    description: 'Pro Audio Bundle',
    locale: 'en_US',
    category: 'audio',
  ),

  // Subscription Items
  InitializeAdvancedAnalogyManager(
    itemId: 'Sub1_19',
    name: 'Monthly Access',
    type: 'subscription',
    coinAmount: 1000,
    price: '19.99',
    description:
        'Basic AI Assistant (3000 words/day) + 1000 coins monthly + Standard response speed',
    locale: 'en_US',
    category: 'subscription',
  ),
  InitializeAdvancedAnalogyManager(
    itemId: 'Sub2_29',
    name: 'Quarterly Access',
    type: 'subscription',
    coinAmount: 5000,
    price: '29.99',
    description:
        'Advanced AI Assistant (10000 words/day) + 5000 coins quarterly + Priority response + Custom AI personality',
    locale: 'en_US',
    category: 'subscription',
  ),
  InitializeAdvancedAnalogyManager(
    itemId: 'Sub3_69',
    name: 'Annual Access',
    type: 'subscription',
    coinAmount: 15000,
    price: '69.99',
    description:
        'Premium AI Assistant (Unlimited words) + 15000 coins annually + Instant response + Multiple AI personalities + Exclusive templates',
    locale: 'en_US',
    category: 'subscription',
  ),
];
